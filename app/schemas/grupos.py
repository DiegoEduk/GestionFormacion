
from pydantic import BaseModel, Field


class getGruposFiltros(BaseModel):
    estado_g: str = Field(min_length=3, max_length=20)
    modalidad: str = Field(min_length=6, max_length=20)
    cod_centro: int

class nivelTotalGrupos(BaseModel):
    nombre_nivel: str
    total: int

class totalGrupoMes(BaseModel):
    total: int
    mes: int