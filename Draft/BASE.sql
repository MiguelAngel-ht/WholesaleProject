



-- BASE

select mMvAFolio, mMvAObservaciones from [10.16.32.33].SIA0111.dbo.mMovAlmacen
WHERE mMvAObservaciones LIKE '%PED ESP%'


-- SÍ SALEN

select mMvAFolio, mMvAObservaciones from [10.16.32.33].SIA0111.dbo.mMovAlmacen
WHERE mMvAObservaciones LIKE '%SEDUCTA%'
AND mMvAObservaciones NOT LIKE '%DEVOL%'

select mMvAFolio, mMvAObservaciones 
INTO Temporales.dbo.tmpVOCFoliosGenova
from [10.16.32.33].SIA0111.dbo.mMovAlmacen
WHERE mMvAObservaciones LIKE '%GENOVA%'

select mMvAFolio, mMvAObservaciones from [10.16.32.33].SIA0111.dbo.mMovAlmacen
WHERE mMvAObservaciones LIKE '%MODA%'

select mMvAFolio, mMvAObservaciones from [10.16.32.33].SIA0111.dbo.mMovAlmacen
WHERE mMvAObservaciones LIKE '%GARDINI%'




