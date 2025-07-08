from sqlalchemy.orm import Session
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from typing import Optional
import logging

from app.schemas.grupos import getGruposFiltros
logger = logging.getLogger(__name__)

def get_nivel_total_grupos_by_centro(db: Session, estado: str, modalidad: str, cod_centro: int):
    try:

        query = text("""
            SELECT nombre_nivel, count(cod_ficha) AS total 
                FROM railway.grupo 
            WHERE estado_grupo = :estado_g
                     AND modalidad = :modalidad
                     AND cod_centro = :cod_centro
            group by nombre_nivel
        """)
        result = db.execute(query, {"estado_g":estado, "modalidad":modalidad, "cod_centro":cod_centro }).mappings().all()
        print(result)
        return result
    except SQLAlchemyError as e:
        logger.error(f"Error al obtener nivel y total grupos por cod_centro: {e}")
        raise Exception("Error de base de datos al obtener nivel y total grupos")
