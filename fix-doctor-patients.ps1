$SUPABASE_URL = "https://kcpooneuqdbdavgivbdp.supabase.co"
$SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM"

$headers = @{
    "apikey" = $SUPABASE_KEY
    "Content-Type" = "application/json"
}

Write-Host "Obteniendo medicos..." -ForegroundColor Cyan

$medResponse = Invoke-WebRequest `
    -Uri "$SUPABASE_URL/rest/v1/medicos?select=id" `
    -Headers $headers `
    -Method GET

$pacResponse = Invoke-WebRequest `
    -Uri "$SUPABASE_URL/rest/v1/perfiles_pacientes?select=id" `
    -Headers $headers `
    -Method GET

$medicos = $medResponse.Content | ConvertFrom-Json
$pacientes = $pacResponse.Content | ConvertFrom-Json

Write-Host "Encontrados: $($medicos.Count) medicos, $($pacientes.Count) pacientes" -ForegroundColor Green

$relaciones = @()
foreach ($medico in $medicos) {
    $numPac = Get-Random -Minimum 5 -Maximum 8
    for ($i = 0; $i -lt $numPac; $i++) {
        $randomPac = $pacientes[(Get-Random -Minimum 0 -Maximum $pacientes.Count)]
        $relaciones += @{
            id_medico = $medico.id
            id_paciente = $randomPac.id
            activo = $true
        }
    }
}

Write-Host "Inyectando $($relaciones.Count) relaciones..." -ForegroundColor Cyan

$body = ($relaciones | ConvertTo-Json -AsArray)

$response = Invoke-WebRequest `
    -Uri "$SUPABASE_URL/rest/v1/doctor_patient_relationships" `
    -Headers $headers `
    -Method POST `
    -Body $body

Write-Host "Respuesta: $($response.StatusCode)" -ForegroundColor Green
Write-Host "Completo! Los pacientes ya deben aparecer." -ForegroundColor Green
