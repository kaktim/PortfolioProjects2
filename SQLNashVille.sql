/*
Cleaning Data in SQL Queries
*/

select *
from [PortfolioProject].[dbo].[NashvilleHousing ]

--Standardize Date Format

select SaleDateconverted, convert(Date,SaleDate)
from [PortfolioProject].[dbo].[NashvilleHousing ]

update [PortfolioProject].[dbo].[NashvilleHousing ]
set SaleDate = convert(Date,SaleDate)

alter table [PortfolioProject].[dbo].[NashvilleHousing ]
add Saledateconverted Date;

update [PortfolioProject].[dbo].[NashvilleHousing ]
set Saledateconverted = convert(Date,SaleDate)

--Populate Property Address data

select *
from [PortfolioProject].[dbo].[NashvilleHousing ]
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
isnull(a.PropertyAddress,b.PropertyAddress)
from [PortfolioProject].[dbo].[NashvilleHousing ] a
join [PortfolioProject].[dbo].[NashvilleHousing ] b
   on a.ParcelID = b.ParcelID
  and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from [PortfolioProject].[dbo].[NashvilleHousing ] a
join [PortfolioProject].[dbo].[NashvilleHousing ] b
   on a.ParcelID = b.ParcelID
  and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from [PortfolioProject].[dbo].[NashvilleHousing ]
--where PropertyAddress is null
--order by ParcelID

select 
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , len(PropertyAddress)) as Address

from [PortfolioProject].[dbo].[NashvilleHousing ]


alter table [PortfolioProject].[dbo].[NashvilleHousing ]
add PropertySplitAddress nvarchar(255);

update [PortfolioProject].[dbo].[NashvilleHousing ]
set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


alter table [PortfolioProject].[dbo].[NashvilleHousing ]
add PropertySplitCity nvarchar(255);

update [PortfolioProject].[dbo].[NashvilleHousing ]
set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , len(PropertyAddress))


select *
from [PortfolioProject].[dbo].[NashvilleHousing ]

select	OwnerAddress
from [PortfolioProject].[dbo].[NashvilleHousing ]

select 
PARSENAME(replace(OwnerAddress, ',', '.') ,3)
,PARSENAME(replace(OwnerAddress, ',', '.') ,2)
,PARSENAME(replace(OwnerAddress, ',', '.') ,1)
from [PortfolioProject].[dbo].[NashvilleHousing ]



alter table [PortfolioProject].[dbo].[NashvilleHousing ]
add OwnerSplitAddress nvarchar(255);

update [PortfolioProject].[dbo].[NashvilleHousing ]
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.') ,3)


alter table [PortfolioProject].[dbo].[NashvilleHousing ]
add OwnerSplitCity nvarchar(255);

update [PortfolioProject].[dbo].[NashvilleHousing ]
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.') ,2)

alter table [PortfolioProject].[dbo].[NashvilleHousing ]
add OwnerSplitState nvarchar(255);

update [PortfolioProject].[dbo].[NashvilleHousing ]
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.') ,1)

select	*
from [PortfolioProject].[dbo].[NashvilleHousing ] 


select	distinct(SoldAsVacant), count(SoldAsVacant)
from [PortfolioProject].[dbo].[NashvilleHousing ] 
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from [PortfolioProject].[dbo].[NashvilleHousing ] 



update [PortfolioProject].[dbo].[NashvilleHousing ]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end

with RowNumCTE as (
select *,
    ROW_NUMBER() over (
    Partition by ParcelID,
                 PropertyAddress,
                 SalePrice,
                 SaleDate,
                 LegalReference
                 order by 
				 UniqueID
				 )row_num

from [PortfolioProject].[dbo].[NashvilleHousing ] 
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress




select *
from [PortfolioProject].[dbo].[NashvilleHousing ] 


alter table [PortfolioProject].[dbo].[NashvilleHousing ] 
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table [PortfolioProject].[dbo].[NashvilleHousing ] 
drop column SaleDate