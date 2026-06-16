-- TRIGGERS AUDITORIA LUISA v2.0

CREATE OR REPLACE FUNCTION fn_auditoria_generica()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO auditoria_acciones (id_usuario, usuario_rol, accion, tabla_afectada, id_registro, valores_anteriores, valores_nuevos)
  VALUES (
    auth.uid(),
    current_setting('request.jwt.claims', true)::json->>'role',
    TG_OP,
    TG_TABLE_NAME,
    COALESCE(NEW.id, OLD.id),
    CASE WHEN TG_OP = 'DELETE' THEN to_jsonb(OLD) ELSE NULL END,
    CASE WHEN TG_OP IN ('INSERT','UPDATE') THEN to_jsonb(NEW) ELSE NULL END
  );
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trig_auditoria_citas ON citas;
CREATE TRIGGER trig_auditoria_citas AFTER INSERT OR UPDATE OR DELETE ON citas FOR EACH ROW EXECUTE FUNCTION fn_auditoria_generica();

DROP TRIGGER IF EXISTS trig_auditoria_historias ON historias_clinicas;
CREATE TRIGGER trig_auditoria_historias AFTER INSERT OR UPDATE OR DELETE ON historias_clinicas FOR EACH ROW EXECUTE FUNCTION fn_auditoria_generica();

DROP TRIGGER IF EXISTS trig_auditoria_pacientes ON perfiles_pacientes;
CREATE TRIGGER trig_auditoria_pacientes AFTER INSERT OR UPDATE OR DELETE ON perfiles_pacientes FOR EACH ROW EXECUTE FUNCTION fn_auditoria_generica();
