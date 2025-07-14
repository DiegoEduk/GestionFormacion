
from typing import Annotated, List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.schemas.grupos import getGruposFiltros, nivelTotalGrupos, totalGrupoMes
from app.schemas.users import UserOut
from core.database import get_db
from app.crud import grupos as grupos_crud
from sqlalchemy.exc import SQLAlchemyError
from core.dependencies import get_current_user
from core.config import settings

router = APIRouter()

@router.get("/get-nivel-total-grupos", response_model=List[nivelTotalGrupos])
def get_nivel_total_grupos(
    estado: str,
    modalidad: str,
    cod_centro: int,
    db: Session = Depends(get_db),
    current_user: UserOut = Depends(get_current_user)
):
    print('inicio endpoint')
    if current_user.id_rol != 1:
        if current_user.id_rol != 2:
            raise HTTPException(status_code=401, detail="Usuario no autorizado")

    try:
        print('inicio consulta')
        totales = grupos_crud.get_nivel_total_grupos_by_centro(db, estado, modalidad, cod_centro)
        if not totales:
            raise HTTPException(status_code=404, detail="No se encontraron datos")
        return totales
    except SQLAlchemyError as e:
        raise HTTPException(status_code=500, detail=str(e))



@router.get("/get-total-groups-by-month", response_model=List[totalGrupoMes])
def get_total_groups_by_month(
    anio: int,
    cod_centro: int,
    db: Session = Depends(get_db),
    current_user: UserOut = Depends(get_current_user)
):
    print('inicio endpoint')
    if current_user.id_rol != 1:
        if current_user.id_rol != 2:
            raise HTTPException(status_code=401, detail="Usuario no autorizado")

    try:
        print('inicio consulta')
        totales = grupos_crud.get_total_grupos_finalizan_por_mes(db, anio, cod_centro)
        if not totales:
            raise HTTPException(status_code=404, detail="No se encontraron datos")
        return totales
    except SQLAlchemyError as e:
        raise HTTPException(status_code=500, detail=str(e))