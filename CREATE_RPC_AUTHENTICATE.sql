- ============================================================================
-- RPC PARA AUTENTICACIÓN CON TABLA usuarios_luisa
-- ============================================================================

CREATE OR REPLACE FUNCTION auth_usuario(
  p_email VARCHAR,
  p_contraseña VARCHAR
)
RETURNS TABLE (
  id UUID,
  email VARCHAR,
  nombre_completo VARCHAR,
  rol VARCHAR,
  autenticado BOOLEAN,
  mensaje VARCHAR
) AS $$
DECLARE
  v_usuario usuarios_luisa%ROWTYPE;
  v_hash_coincide BOOLEAN;
BEGIN
  -- Buscar usuario por email
  SELECT * INTO v_usuario
  FROM usuarios_luisa
  WHERE email = p_email AND activo = true
  LIMIT 1;

  -- Si no existe
  IF v_usuario IS NULL THEN
    RETURN QUERY SELECT
      NULL::UUID,
      p_email,
      NULL::VARCHAR,
      NULL::VARCHAR,
      false,
      'Usuario no encontrado';
    RETURN;
  END IF;

  -- Verificar contraseña con bcrypt
  v_hash_coincide := (crypt(p_contraseña, v_usuario.contraseña_hash) = v_usuario.contraseña_hash);

  -- Si contraseña no coincide
  IF NOT v_hash_coincide THEN
    RETURN QUERY SELECT
      v_usuario.id,
      v_usuario.email,
      v_usuario.nombre_completo,
      v_usuario.rol,
      false,
      'Contraseña incorrecta';
    RETURN;
  END IF;

  -- Éxito
  RETURN QUERY SELECT
    v_usuario.id,
    v_usuario.email,
    v_usuario.nombre_completo,
    v_usuario.rol,
    true,
    'Autenticación exitosa';

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- GRANT PERMISSIONS
-- ============================================================================

GRANT EXECUTE ON FUNCTION auth_usuario(VARCHAR, VARCHAR) TO anon, authenticated;

-- ============================================================================
-- FIN - FUNCTION CREATED
-- ============================================================================
