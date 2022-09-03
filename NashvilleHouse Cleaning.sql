/*

Cleaning data with sql queries

*/

select *
from PortfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------

-- Standardize Date format

select SaleDateConverted, CONVERT(Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--------------------------------------------------------------------------------------------------------------------------------


-- Populate Property Address data


select *
from PortfolioProject.dbo.NashvilleHousing
-- where PropertyAddress is not null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
     ON a.ParcelID = b.parcelID
	 AND a.[UniqueID]  <> b.[UniqueID]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
     ON a.ParcelID = b.parcelID
	 AND a.[UniqueID]  <> b.[UniqueID]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out address into Individual Columns (Address, City, state)

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
add PropertysplitAdress Nvarchar(255);

update NashvilleHousing
SET  PropertysplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
add PropertysplitCity nvarchar(255);

Update NashvilleHousing
SET PropertysplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


select *
from PortfolioProject.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------

--Owner Address

select ownerAddress
from PortfolioProject.dbo.NashvilleHousing

select
PARSENAME(REPLACE(ownerAddress, ',','.'), 3)
, PARSENAME(REPLACE(ownerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(ownerAddress, ',', '.'), 1)
from PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
add ownerAddresssplitAdress Nvarchar(255);

update NashvilleHousing
SET  ownerAddresssplitAdress = PARSENAME(REPLACE(ownerAddress, ',','.'), 3)

ALTER TABLE NashvilleHousing
add ownerAddresssplitCity nvarchar(255);  

Update NashvilleHousing
SET ownerAddresssplitCity = PARSENAME(REPLACE(ownerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
add ownerAddresssplitstate nvarchar(255);

Update NashvilleHousing
SET ownerAddresssplitstate = PARSENAME(REPLACE(ownerAddress, ',', '.'), 1)


select *
from PortfolioProject.dbo.NashvilleHousing


------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "sold as vacant" field

select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, Case when SoldAsVacant = 'Y' Then 'Yes'
       when SoldAsVacant = 'N' Then 'No'
       Else SoldAsvacant
       End
from PortfolioProject.dbo.NashvilleHousing


update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
    When SoldAsVacant = 'N' Then 'No'
	ELSE SoldAsVacant
	END


--------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE AS(
select *,
      ROW_NUMBER() OVER(
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY 
				          UniqueID
						  ) row_num


from PortfolioProject.dbo.NashvilleHousing
)

-- DELETE
select *
from RowNUMCTE
where row_num >1
order by PropertyAddress


-----------------------------------------------------------------------------------

-- Delete Unused columns

select * 
from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE POrtfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate












