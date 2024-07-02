select * from accident
select * from vehicle

--how many accidents have occured in urban areas versus rural areas
select area, count(AccidentIndex) as 'total accidents'
from accident
group by area

--which day of the week have the highest number of aciidents?
select day, count(AccidentIndex) as total_accidents
from accident
group by day
order by total_accidents desc

--what is the average age of vehicle involveld in the accidentbased on the type
select VehicleType, AVG(AgeVehicle) as average_age , count(AccidentIndex) as total_accidents
from vehicle
where AgeVehicle is not null
group by VehicleType
order by total_accidents desc

--can we identify any trends in accidents based on the age of the vehicle involved?
select AgeGroup,avg(AgeVehicle) as avg_year, count(AccidentIndex) as total_accidents
from (select 
        AccidentIndex, 
		AgeVehicle,
		case
		    when AgeVehicle between 0 and 5 then 'New'
			when AgeVehicle between 6 and 10 then 'Regular'
			else 'Old'
		end as 'AgeGroup'
	from vehicle) as subquery
group by AgeGroup

declare @severity varchar(100)
set @severity= 'Fatal'
--are there any specific weather conditions that contribute to severe accident?
select count(Severity) as total_accidents, WeatherConditions
from accident
where Severity= @severity
group by WeatherConditions
order by total_accidents desc

--do accidents often involved in the left side of the vehicle?
select count(AccidentIndex) as total_accidents, LeftHand
from vehicle
group by LeftHand
having LeftHand is not null

--are there any relationships between journey purposes and severity of accidents?

select v.JourneyPurpose, count(a.Severity) as total_accidents,
       case
	      when  count(a.Severity) between 0 and 1000 then 'Low'
		  when  count(a.Severity) between 1001 and 3000 then 'Moderate'
		  else 'High'
		end as 'Level'
from accident a
join vehicle as v on v.AccidentIndex= a.AccidentIndex
where severity = 'Fatal'
group by v.JourneyPurpose
order by total_accidents desc

--calculate the avg age of vehicles involveld in accidents considering daylight and point of impact
select avg(v.AgeVehicle) as avg_year, v.PointImpact, a.LightConditions
from vehicle v
join accident a  on v.AccidentIndex= a.AccidentIndex
--where a.LightConditions= 'Daylight'
group by v.PointImpact, a.LightConditions
having a.LightConditions= 'Daylight'
 --or to have the automated variable we can do as follows:
 --declare@impact varchar(100)
 --declare@ilight varchar(100)
 --set @impact = 'NearSide'
  --set @light = 'Daylight'