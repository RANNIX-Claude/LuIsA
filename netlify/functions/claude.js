// netlify/functions/claude.js
// Proxy seguro — Claude API
// LIGIA v2.0

const CORS = {
  "Access-Control-Allow-Origin":  "*",
  "Access-Control-Allow-Headers": "Content-Type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Content-Type": "application/json",
};

exports.handler = async (event) => {

  // Preflight CORS
  if (event.httpMethod === "OPTIONS") {
    return { statusCode: 200, headers: CORS, body: "" };
  }

  // Solo POST
  if (event.httpMethod !== "POST") {
    return { statusCode: 405, headers: CORS, body: JSON.stringify({ error: "Method Not Allowed" }) };
  }

  // Verificar que el API key existe
  if (!process.env.ANTHROPIC_API_KEY) {
    return {
      statusCode: 500,
      headers: CORS,
      body: JSON.stringify({ error: { message: "ANTHROPIC_API_KEY no configurado en Netlify Environment Variables" } }),
    };
  }

  try {
    const body = JSON.parse(event.body);

    // Normalizar modelo: aceptar nombres viejos y nuevos
    const modelMap = {
      'claude-sonnet-4-6': 'claude-sonnet-4-20250514',
      'claude-opus-4-1':   'claude-opus-4-20250514',
      'claude-sonnet-4':   'claude-sonnet-4-20250514',
    };
    if (body.model && modelMap[body.model]) {
      body.model = modelMap[body.model];
    }
    // Default model si no especifican
    if (!body.model) {
      body.model = 'claude-sonnet-4-20250514';
    }

    const response = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "Content-Type":      "application/json",
        "x-api-key":         process.env.ANTHROPIC_API_KEY,
        "anthropic-version": "2023-06-01",
      },
      body: JSON.stringify(body),
    });

    const data = await response.json();

    return {
      statusCode: response.status,
      headers: CORS,
      body: JSON.stringify(data),
    };

  } catch (err) {
    console.error("Error en proxy Claude:", err);
    return {
      statusCode: 500,
      headers: CORS,
      body: JSON.stringify({ error: { message: err.message } }),
    };
  }
};
