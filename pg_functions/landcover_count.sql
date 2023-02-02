select modis_landcover, count(*) as "lc_number"
from public_test."geoIndicators"
where "State" = 'NM'
GROUP BY modis_landcover
ORDER BY lc_number desc;