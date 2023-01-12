use housing
 select *from nashvillehousing

 select saledate from nashvillehousing

 --standradize date 
 select convert (date,saledate) from nashvillehousing  -- take only from column the date

 alter table nashvillehousing  add saledateconverted date -- add new column to save the new saledate format 

 update nashvillehousing set saledateconverted=convert (date,saledate) -- now save the formated saledate 

 select saledateconverted from nashvillehousing 

 --  fill the nulls in  property address data 

  select PropertyAddress from nashvillehousing  where PropertyAddress is null 

  select a.ParcelID,a.PropertyAddress,b.ParcelID ,b.PropertyAddress ,isnull(a.PropertyAddress,b.PropertyAddress) -- if the  a.PropertyAddress then but the value of b.PropertyAddress  on it 
  
  from  nashvillehousing a join nashvillehousing b on  a.ParcelID = b.ParcelID and a.[UniqueID ]<>b.[UniqueID ] --  (<> ==> this mean not equal)===> self join the table with it self to fill the nulls using the parceid 
  where a.PropertyAddress is null 

  -- ubdate the table with no nulls in property address 
  update a 
  set propertyaddress =isnull(a.PropertyAddress,b.PropertyAddress)
   from  nashvillehousing a join nashvillehousing b on  a.ParcelID = b.ParcelID and a.[UniqueID ]<>b.[UniqueID ] -- self join the table with it self to fill the nulls using the parceid 
  where a.PropertyAddress is null


  --seperate the address column into different parts (city ,state ,address)

  select propertyaddress from nashvillehousing

select SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress))as "address",  -- 1 mean start from first letter and found the ',' and take what before the ','
SUBSTRING(propertyaddress,CHARINDEX(',',PropertyAddress) +1  ,len (PropertyAddress)) as "address" --  to split the city from proprrty address instead of but 1 as aposition we but CHARINDEX(',',PropertyAddress) as a position because char index return a number which indecate where is the ','
from nashvillehousing

 -- ubdate the table with new valus and 2 column  city and address

  alter table nashvillehousing  add  splitaddress nvarchar (255)

 update nashvillehousing set  splitaddress = SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress))

  alter table nashvillehousing  add splitcity nvarchar(255)

 update nashvillehousing set splitcity=SUBSTRING(propertyaddress,CHARINDEX(',',PropertyAddress) +1  ,len (PropertyAddress))

 select*from nashvillehousing -- just for check



 --split owner address using different method

 select OwnerAddress from nashvillehousing 
 select PARSENAME(REPLACE (owneraddress,',' ,'.'),3),PARSENAME(REPLACE (owneraddress,',' ,'.'),2),PARSENAME(REPLACE (owneraddress, ',' ,'.'),1)

 from nashvillehousing

 --ubdate the table with the new seperated value

 
  alter table nashvillehousing  add  ownersplitaddress nvarchar (255)

 update nashvillehousing set  ownersplitaddress = PARSENAME(REPLACE (owneraddress,',' ,'.'),3)

  alter table nashvillehousing  add ownersplitcity nvarchar(255)

 update nashvillehousing set ownersplitcity=PARSENAME(REPLACE (owneraddress,',' ,'.'),2)

   alter table nashvillehousing  add ownersplitstate nvarchar(255)

 update nashvillehousing set ownersplitstate=PARSENAME(REPLACE (owneraddress, ',' ,'.'),1)

 select*from nashvillehousing


 -- convert y to yes and n to no in 'soldvsvacnt column

 select SoldAsVacant ,
 case  when SoldAsVacant = 'y' then 'yes'
  when SoldAsVacant = 'n' then 'no'
  else SoldAsVacant
  end
 from nashvillehousing

 update nashvillehousing 

 set SoldAsVacant= case  when SoldAsVacant = 'y' then 'yes'
  when SoldAsVacant = 'n' then 'no'
  else SoldAsVacant
  end

  --- remove the duplicates
  with rownumcte AS (
  select *,
ROW_NUMBER() over (partition by parcelID,propertyaddress,saleprice,saledate,legalreference order by uniqueID) row_num
  from nashvillehousing)

  
 select *from rownumcte
  where row_num>1 order by PropertyAddress

 -- delete all duplicate now 
 delete from rownumcte
  where  row_num >1

  -- delete the unused column 
  select *from nashvillehousing

  alter table nashvillehousing 
  drop column owneraddress ,taxdistrict,propertyaddress



