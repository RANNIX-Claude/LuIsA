#!/usr/bin/env python3
import requests
import json
import uuid
from datetime import datetime, timedelta
import random
import time

# Credenciales Supabase
SUPABASE_URL = "https://kcpooneuqdbdavgivbdp.supabase.co"
SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjcG9vbmV1cWRiZGF2Z2l2YmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1MTE3NDgsImV4cCI6MjA5NzA4Nzc0OH0.dWOhArXA8rv0Jzm-gajRlXtPkuwEg66GNF1YdygidNM"

headers = {
    "Authorization": f"Bearer {SUPABASE_ANON_KEY}",
    "apikey": SUPABASE_ANON_KEY,
    "Content-Type": "application/json"
}

# Datos para generación
NOMBRES_PACIENTES = [
    "María González López", "Juan García Rodríguez", "Ana Martínez Fernández",
    "Carlos López Hernández", "Roberto Jiménez Gutiérrez", "Laura Moreno Pérez",
    "Francisco Torres Ramírez", "Rosa Díaz Castillo", "Antonio Sánchez Montoya",
    "Carmen Ruiz Medina", "David Herrera Campos", "María Elena Rojas Silva",
    "Miguel Ángel Flores Cruz", "Patricia Vargas Reyes", "Jesús Morales Rivas",
    "Alejandra Medina Gómez", "Ricardo Navarro Acosta", "Claudia Esparza Bautista",
    "Felipe Campos López", "Verónica Gutierrez Miranda"
]

DIAGNOSTICOS = [
    "E11 - Diabetes mellitus tipo 2",
    "I10 - Hipertensión esencial",
    "E78 - Hiperlipidemia",
    "M19 - Artrosis",
    "E66 - Obesidad",
    "J30 - Rinitis alérgica",
    "K21 - Enfermedad del reflujo gastroesofágico",
    "F41 - Trastornos de ansiedad",
    "E05 - Tirotoxicosis",
    "G89 - Dolor no clasificado"
]

NOTAS_SUBJETIVAS = [
    "Paciente refiere dolor de cabeza intermitente desde hace 3 días, acompañado de mareos al cambiar de posición.",
    "Consulta por control de diabetes mellitus tipo 2. Refiere cumplimiento con medicamentos. Glucemias en casa promedio 140-160.",
    "Paciente acude por molestias abdominales postprandiales. Niega síntomas de alarma. Toma omeprazol regularmente.",
    "Refiere fatiga generalizada y dificultad para concentrarse en el trabajo durante la última semana.",
    "Paciente reporta aumento de peso de 3 kg en el último mes a pesar de dieta. Sigue siendo sedentario.",
    "Acude por revisión de presión arterial. Reporta stress laboral importante. Cumple con antihipertensivos.",
    "Consulta por molestia en articulación de rodilla izquierda al subir escaleras hace 2 semanas."
]

NOTAS_OBJETIVAS = [
    "TA: 145/92, FC: 78, FR: 16, Temp: 36.8, Peso: 85kg, Talla: 1.75m, IMC: 27.8",
    "TA: 130/85, FC: 72, FR: 14, Temp: 36.9, Peso: 78kg, Talla: 1.68m, IMC: 27.6",
    "TA: 155/95, FC: 82, FR: 17, Temp: 37.0, Peso: 92kg, Talla: 1.72m, IMC: 31.1",
    "TA: 125/80, FC: 70, FR: 15, Temp: 36.7, Peso: 70kg, Talla: 1.65m, IMC: 25.7",
    "TA: 140/88, FC: 75, FR: 16, Temp: 36.8, Peso: 88kg, Talla: 1.80m, IMC: 27.2"
]

MEDICAMENTOS_COMUNES = [
    "Metformina 500mg", "Lisinopril 10mg", "Simvastatina 20mg", "Omeprazol 20mg",
    "Ibuprofen 400mg", "Amoxicilina 500mg", "Loratadina 10mg", "Sertraline 50mg",
    "Levotiroxina 75mcg", "Losartan 50mg"
]

VACUNAS = [
    "Influenza", "COVID-19", "Hepatitis B", "Tétanos", "Neumocócica",
    "Herpes Zóster", "Meningocócica", "Tosferina", "Sarampión", "Varicela"
]

MEDICOS = [f"medico{i:03d}" for i in range(1, 11)]

def generate_birth_date():
    """Generar fecha de nacimiento entre 18 y 85 años"""
    today = datetime.now()
    min_age = 18
    max_age = 85
    days_back = random.randint(min_age * 365, max_age * 365)
    return (today - timedelta(days=days_back)).strftime('%Y-%m-%d')

def generate_future_date():
    """Generar fecha entre hoy y los próximos 7 días"""
    today = datetime.now()
    days_ahead = random.randint(1, 7)
    future_date = today + timedelta(days=days_ahead)
    hour = random.randint(8, 16)
    minute = random.choice([0, 15, 30, 45])
    return future_date.replace(hour=hour, minute=minute, second=0, microsecond=0).strftime('%Y-%m-%dT%H:%M:%S')

def post_to_supabase(table, data):
    """POST a Supabase REST API"""
    try:
        url = f"{SUPABASE_URL}/rest/v1/{table}"
        response = requests.post(url, headers=headers, json=data, timeout=10)

        if response.status_code in [200, 201]:
            return True
        else:
            print(f"  ✗ Error ({response.status_code}): {response.text[:100]}")
            return False
    except Exception as e:
        print(f"  ✗ Exception: {str(e)[:100]}")
        return False

print("=" * 60)
print("GENERADOR DE DATOS DE PRUEBA - LUISA v2.0")
print("=" * 60)
print(f"Timestamp: {datetime.now()}")
print()

# Contadores
counts = {
    'pacientes': 0,
    'citas': 0,
    'notas': 0,
    'medicamentos': 0,
    'vacunas': 0
}

# FASE 1: Crear 20 pacientes
print("[1/5] Creando 20 pacientes con perfiles...")
patient_ids = []

for i in range(1, 21):
    patient_id = str(uuid.uuid4())
    patient_ids.append(patient_id)

    nombre = NOMBRES_PACIENTES[i - 1]
    cedula = 100000000 + i
    fecha_nac = generate_birth_date()
    estado_id = (i % 32) + 1
    sangre_id = (i % 8) + 1
    ocupacion_id = (i % 7) + 1
    sexo = 'F' if i % 2 == 0 else 'M'

    # Crear usuario
    user_data = {
        "id": patient_id,
        "email": f"paciente{i:03d}@example.mx",
        "tipo_usuario": "paciente",
        "estado_activo": True
    }

    if post_to_supabase("usuarios_luisa", user_data):
        counts['pacientes'] += 1

    time.sleep(0.1)  # Rate limit

    # Crear perfil paciente
    profile_data = {
        "id": patient_id,
        "nombre_completo": nombre,
        "cedula_profesional": str(cedula),
        "fecha_nacimiento": fecha_nac,
        "sexo": sexo,
        "estado_republica_id": estado_id,
        "tipo_sanguineo_id": sangre_id,
        "ocupacion_id": ocupacion_id,
        "telefono": f"{5500000000 + i}",
        "direccion": f"Calle {nombre} {i}, Depto {i*2}, México",
        "alergias": "Penicilina, Látex" if i % 3 == 0 else "Ninguna conocida",
        "comorbilidades": "Diabetes mellitus tipo 2, Hipertensión" if i % 2 == 0 else "Ninguna"
    }

    if post_to_supabase("perfiles_pacientes", profile_data):
        print(f"  ✓ Paciente {i}: {nombre}")

    time.sleep(0.1)

print()
print("[2/5] Creando 30 citas distribuidas...")

for i in range(1, 31):
    cita_id = str(uuid.uuid4())
    fecha_cita = generate_future_date()
    medico_idx = i % len(MEDICOS)
    paciente_idx = i % len(patient_ids)

    cita_data = {
        "id": cita_id,
        "medico_id": MEDICOS[medico_idx],
        "paciente_id": patient_ids[paciente_idx],
        "fecha_hora": fecha_cita,
        "duracion_minutos": 30,
        "estado": "programada",
        "motivo_consulta": "Control rutinario de salud",
        "notas": "Cita de revisión periódica"
    }

    if post_to_supabase("citas", cita_data):
        counts['citas'] += 1
        print(f"  ✓ Cita {i}")

    time.sleep(0.1)

print()
print("[3/5] Creando 15 notas de evolución clínica...")

for i in range(1, 16):
    nota_id = str(uuid.uuid4())
    paciente_idx = i % len(patient_ids)
    diagnostico = DIAGNOSTICOS[i % len(DIAGNOSTICOS)]

    subjetiva = NOTAS_SUBJETIVAS[i % len(NOTAS_SUBJETIVAS)]
    objetiva = NOTAS_OBJETIVAS[i % len(NOTAS_OBJETIVAS)]

    nota_data = {
        "id": nota_id,
        "paciente_id": patient_ids[paciente_idx],
        "medico_id": MEDICOS[i % len(MEDICOS)],
        "fecha_creacion": datetime.now().strftime('%Y-%m-%dT%H:%M:%S.000Z'),
        "subjetivo": subjetiva,
        "objetivo": objetiva,
        "diagnostico": diagnostico,
        "plan_tratamiento": "Continuar con medicamentos actuales. Realizar seguimiento en 4 semanas."
    }

    if post_to_supabase("notas_evolucion", nota_data):
        counts['notas'] += 1
        print(f"  ✓ Nota de evolución {i}")

    time.sleep(0.1)

print()
print("[4/5] Creando 25 medicamentos asignados...")

dosis_options = ["1 tableta", "2 tabletas", "1 cápsula", "2 cápsulas", "5 ml", "10 ml"]
frecuencias_id = [1, 2, 3, 4, 5, 6]

for i in range(1, 26):
    medic_id = str(uuid.uuid4())
    paciente_idx = i % len(patient_ids)

    medicamento = MEDICAMENTOS_COMUNES[i % len(MEDICAMENTOS_COMUNES)]
    dosis = dosis_options[i % len(dosis_options)]
    frecuencia_id = frecuencias_id[i % len(frecuencias_id)]

    fecha_inicio = datetime.now().strftime('%Y-%m-%d')
    fecha_fin = (datetime.now() + timedelta(days=30)).strftime('%Y-%m-%d')

    medic_data = {
        "id": medic_id,
        "paciente_id": patient_ids[paciente_idx],
        "nombre_medicamento": medicamento,
        "dosis": dosis,
        "frecuencia_id": frecuencia_id,
        "via_administracion_id": (i % 5) + 1,
        "fecha_inicio": fecha_inicio,
        "fecha_fin": fecha_fin,
        "indicaciones": "Tomar según se prescribe para el tratamiento",
        "efectos_secundarios": "Ninguno conocido"
    }

    if post_to_supabase("medicamentos_paciente", medic_data):
        counts['medicamentos'] += 1
        print(f"  ✓ Medicamento {i}: {medicamento}")

    time.sleep(0.1)

print()
print("[5/5] Creando 10 registros de vacunas...")

for i in range(1, 11):
    vacuna_id = str(uuid.uuid4())
    paciente_idx = i % len(patient_ids)
    vacuna = VACUNAS[i - 1]

    dias_atras = random.randint(1, 365)
    fecha_vacuna = (datetime.now() - timedelta(days=dias_atras)).strftime('%Y-%m-%d')
    proxima_dosis = (datetime.now() + timedelta(days=365)).strftime('%Y-%m-%d')

    vacuna_data = {
        "id": vacuna_id,
        "paciente_id": patient_ids[paciente_idx],
        "nombre_vacuna": vacuna,
        "fecha_aplicacion": fecha_vacuna,
        "dosis_numero": 1,
        "lote": f"LOTE{1000000 + i:08d}",
        "proxima_dosis": proxima_dosis
    }

    if post_to_supabase("vacunas_paciente", vacuna_data):
        counts['vacunas'] += 1
        print(f"  ✓ Vacuna {i}: {vacuna}")

    time.sleep(0.1)

print()
print("=" * 60)
print("RESUMEN DE DATOS CREADOS")
print("=" * 60)
print(f"✓ Pacientes (usuarios + perfiles):  {counts['pacientes']}")
print(f"✓ Citas creadas:                    {counts['citas']}")
print(f"✓ Notas de evolución:               {counts['notas']}")
print(f"✓ Medicamentos asignados:           {counts['medicamentos']}")
print(f"✓ Vacunas registradas:              {counts['vacunas']}")
print(f"\nTotal de registros:                 {sum(counts.values())}")
print(f"Timestamp finalización:             {datetime.now()}")
print("=" * 60)
