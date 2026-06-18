#!/bin/bash

SUPABASE_URL="https://kcpooneuqdbdavgivbdp.supabase.co/rest/v1"
ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM"

#Get one medico and paciente ID
echo "Getting sample UUIDs..."
MED_ID=$(curl -s "$SUPABASE_URL/medicos?select=id&limit=1" -H "apikey: $ANON_KEY" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
PAC_ID=$(curl -s "$SUPABASE_URL/perfiles_pacientes?select=id&limit=1" -H "apikey: $ANON_KEY" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

echo "Medico ID: $MED_ID"
echo "Paciente ID: $PAC_ID"
echo ""

# Insert 50 notas in 10 batches of 5
echo "Inserting Notas de Evolución..."
notas_total=0

for batch_num in {1..10}; do
  # Create JSON payload with 5 records
  payload="["
  for i in {1..5}; do
    if [ $i -gt 1 ]; then payload="$payload,"; fi
    days=$((RANDOM % 30))
    payload="$payload{\"id_medico\":\"$MED_ID\",\"id_paciente\":\"$PAC_ID\",\"fecha_nota\":\"2026-$(printf '%02d' $((RANDOM % 12 + 1)))-$(printf '%02d' $((RANDOM % 28 + 1)))T00:00:00Z\",\"evolucion_cuadro_clinico\":\"Paciente con evolución favorable\"}"
  done
  payload="$payload]"

  response=$(curl -s -w "\n%{http_code}" -X POST "$SUPABASE_URL/notas_evolucion" \
    -H "apikey: $ANON_KEY" \
    -H "Authorization: Bearer $ANON_KEY" \
    -H "Content-Type: application/json" \
    -H "Prefer: return=representation" \
    -d "$payload")

  http_code=$(echo "$response" | tail -1)
  body=$(echo "$response" | head -n -1)
  count=$(echo "$body" | grep -o '"id":"' | wc -l)
  notas_total=$((notas_total + count))
  
  echo "  Batch $batch_num: $count inserted (HTTP $http_code)"
  sleep 0.5
done

echo "Total Notas: $notas_total"
echo ""

# Insert 20 historias in 4 batches of 5
echo "Inserting Historias Clínicas..."
hist_total=0

for batch_num in {1..4}; do
  payload="["
  for i in {1..5}; do
    if [ $i -gt 1 ]; then payload="$payload,"; fi
    payload="$payload{\"id_medico\":\"$MED_ID\",\"id_paciente\":\"$PAC_ID\",\"fecha_elaboracion\":\"2026-06-17T00:00:00Z\",\"padecimiento_actual\":\"Control de enfermedad crónica\"}"
  done
  payload="$payload]"

  response=$(curl -s -w "\n%{http_code}" -X POST "$SUPABASE_URL/historias_clinicas" \
    -H "apikey: $ANON_KEY" \
    -H "Authorization: Bearer $ANON_KEY" \
    -H "Content-Type: application/json" \
    -H "Prefer: return=representation" \
    -d "$payload")

  http_code=$(echo "$response" | tail -1)
  body=$(echo "$response" | head -n -1)
  count=$(echo "$body" | grep -o '"id":"' | wc -l)
  hist_total=$((hist_total + count))
  
  echo "  Batch $batch_num: $count inserted (HTTP $http_code)"
  sleep 0.5
done

echo "Total Historias: $hist_total"
echo ""

echo "=== FINAL SUMMARY ==="
echo "Notas de Evolución: $notas_total records inserted"
echo "Vacunas Paciente: 25 records inserted"
echo "Historias Clínicas: $hist_total records inserted"
echo "TOTAL: $((notas_total + 25 + hist_total)) records inserted"

