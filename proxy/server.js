import express from 'express';
import rateLimit from 'express-rate-limit';

const app = express();
app.use(express.json({ limit: '32kb' }));

const PORT = process.env.PORT || 8088;
const OPENAI_API_KEY = process.env.OPENAI_API_KEY || '';
const OPENAI_MODEL = process.env.OPENAI_MODEL || 'gpt-4o-mini';
const GEMINI_API_KEY = process.env.GEMINI_API_KEY || '';
const GEMINI_MODEL = process.env.GEMINI_MODEL || 'gemini-2.0-flash';

app.use(
  rateLimit({
    windowMs: 60 * 60 * 1000,
    max: 60,
    standardHeaders: true,
    legacyHeaders: false,
  }),
);

app.get('/health', (_req, res) => res.json({ ok: true }));

app.post('/v1/motivate', async (req, res) => {
  const prompt = (req.body?.prompt || '').toString().slice(0, 6000);
  if (!prompt) return res.status(400).json({ error: 'prompt required' });

  try {
    let text = null;
    if (OPENAI_API_KEY) {
      text = await callOpenAi(prompt);
    } else if (GEMINI_API_KEY) {
      text = await callGemini(prompt);
    } else {
      return res.status(503).json({ error: 'No LLM key configured on server' });
    }
    if (!text) return res.status(502).json({ error: 'empty model response' });
    return res.json({ text });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: 'upstream_failed' });
  }
});

async function callOpenAi(prompt) {
  const r = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${OPENAI_API_KEY}`,
    },
    body: JSON.stringify({
      model: OPENAI_MODEL,
      messages: [{ role: 'user', content: prompt }],
      temperature: 0.7,
      max_tokens: 220,
    }),
  });
  if (!r.ok) throw new Error(`openai ${r.status}`);
  const data = await r.json();
  return data?.choices?.[0]?.message?.content?.trim() || null;
}

async function callGemini(prompt) {
  const url =
    `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${GEMINI_API_KEY}`;
  const r = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      contents: [{ parts: [{ text: prompt }] }],
    }),
  });
  if (!r.ok) throw new Error(`gemini ${r.status}`);
  const data = await r.json();
  return data?.candidates?.[0]?.content?.parts?.[0]?.text?.trim() || null;
}

app.listen(PORT, () => {
  console.log(`gun-sayac ai proxy on :${PORT}`);
});