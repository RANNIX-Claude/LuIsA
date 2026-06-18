# Script para inyectar relaciones doctor-paciente en Supabase
# Genera 5-6 pacientes por médico distribuidos aleatoriamente

$SUPABASE_URL = "https://kcpooneuqdbdavgivbdp.supabase.co"
$SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM"

# Paso 1: Obtener todos los médicos
Write-Host "Obteniendo medicos..." -ForegroundColor Cyan
$headers = @{
    "apikey" = $SUPABASE_KEY
    "Content-Type" = "application/json"
}

$medicos = Invoke-WebRequest -Uri "$SUPABASE_URL/rest/v1/medicos?select=id" `
    -Headers $headers -Method GET | ConvertFrom-Json

$pacientes = Invoke-WebRequest -Uri "$SUPABASE_URL/rest/v1/perfiles_pacientes?select=id" `
    -Headers $headers -Method GET | ConvertFrom-Json

Write-Host "Medicos: $($medicos.Count)" -ForegroundColor Green
Write-Host "Pacientes: $($pacientes.Count)" -ForegroundColor Green

# Paso 2: Crear relaciones (5-6 pacientes por medico)
Write-Host "Generando relaciones doctor-paciente..." -ForegroundColor Cyan

$relaciones = @()
$pacientsPerDoc = [Math]::Ceiling($pacientes.Count / $medicos.Count)

foreach ($doc in $medicos) {
    for ($i = 0; $i -lt $pacientsPerDoc; $i++) {
        $randomIdx = Get-Random -Minimum 0 -Maximum $pacientes.Count
        $relaciones += @{
            medico_id = $doc.id
            paciente_id = $pacientes[$randomIdx].id
            fecha_asignacion = (Get-Date -Format "yyyy-MM-dd")
        }
    }
}

Write-Host "Total relaciones a crear: $($relaciones.Count)" -ForegroundColor Cyan

# Paso 3: Insertar en lotes de 100
$batchSize = 100
for ($i = 0; $i -lt $relaciones.Count; $i += $batchSize) {
    $batch = $relaciones[$i..([Math]::Min($i + $batchSize - 1, $relaciones.Count - 1))]

    $body = ConvertTo-Json $batch
    try {
        Invoke-WebRequest -Uri "$SUPABASE_URL/rest/v1/doctor_patient_relationships" `
            -Headers $headers -Method POST `
            -Body $body | Out-Null
        Write-Host "Lote $([Math]::Ceiling(($i + 1) / $batchSize)): $($batch.Count) relaciones insertadas" -ForegroundColor Green
    } catch {
        Write-Host "Error en lote: $($_)" -ForegroundColor Red
    }
}

Write-Host "Relaciones inyectadas exitosamente!" -ForegroundColor Green
