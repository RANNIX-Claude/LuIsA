#!/bin/bash

SUPABASE_URL="https://kcpooneuqdbdavgivbdp.supabase.co"
SUPABASE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM"

echo "Obteniendo medicos..."
medicos=$(curl -s -H "apikey: $SUPABASE_KEY" "$SUPABASE_URL/rest/v1/medicos?select=id")
echo "Medicos: $(echo "$medicos" | jq '. | length')"

echo "Obteniendo pacientes..."
pacientes=$(curl -s -H "apikey: $SUPABASE_KEY" "$SUPABASE_URL/rest/v1/perfiles_pacientes?select=id")
echo "Pacientes: $(echo "$pacientes" | jq '. | length')"

# Crear relaciones (5-7 pacientes por medico)
echo "Generando relaciones..."
relaciones=$(echo "$medicos" | jq -r '.[] | .id' | while read medico_id; do
  for i in {1..6}; do
    paciente_id=$(echo "$pacientes" | jq -r ".[$(($RANDOM % $(echo "$pacientes" | jq '. | length')))] | .id")
    echo "{\"id_medico\":\"$medico_id\",\"id_paciente\":\"$paciente_id\",\"activo\":true}"
  done
done)

total=$(echo "$relaciones" | wc -l)
echo "Total relaciones a inyectar: $total"

# Convertir a JSON array
json_array="[$(echo "$relaciones" | paste -sd, -)]"

echo "Inyectando en Supabase..."
response=$(curl -s -X POST \
  -H "apikey: $SUPABASE_KEY" \
  -H "Content-Type: application/json" \
  -d "$json_array" \
  "$SUPABASE_URL/rest/v1/doctor_patient_relationships")

echo "Respuesta: $response"
echo "¡Completo! Los pacientes ya deben aparecer en el dashboard."
