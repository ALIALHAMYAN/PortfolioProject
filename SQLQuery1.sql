
------ Cleaning Data in SQL Queries 

 ----- Standardize Data Format 

  select SaleDateConverted 
  from PortfolioProject..NashvilleHousing 

  
  alter table NashvilleHousing 
  add SaleDateConverted Date ;

  update NashvilleHousing 
  set SaleDateConverted = convert ( Date , SaleDate ) 


  ----- Populate Property Address Data
  
 

   ----- Replace the Null value from PropertyAddress by the ParcelID 

   update a 
   set propertyaddress = isnull ( a.propertyaddress , b.propertyAddress)
   from PortfolioProject ..NashvilleHousing a
   join PortfolioProject..NashvilleHousing b
   on a.ParcelID = b.ParcelID
   and a.[UniqueID ] <> b.[UniqueID ] 
   where a.PropertyAddress is null 
   
   -------- Breaking out Address into Individual Colums ( Address, City , State ) 

   select 
   SUBSTRING (propertyaddress, 1, charindex( ',' , propertyaddress) -1 ) as Address 
   , SUBSTRING (propertyaddress ,  charindex ( ',', propertyaddress ) +1 , len(propertyaddress))  as Address 
    from PortfolioProject..NashvilleHousing 


	ALTER Table PortfolioProject..NashvilleHousing  
	add PropertySplitAddress Nvarchar (255) ; 

	update PortfolioProject..NashvilleHousing 
	set PropertySplitAddress = SUBSTRING ( propertyaddress,1, charindex ( ',' , propertyaddress ) -1 ) 


	ALTER Table PortfolioProject..NashvilleHousing 
	add propertySplitCity nvarchar (255) ;

	update PortfolioProject..NashvilleHousing 
	set propertySplitCity =  SUBSTRING ( propertyaddress , charindex ( ',' , propertyaddress ) +1 , len ( propertyaddress )) 

	select * 
	from PortfolioProject..NashvilleHousing

	--------  now i will split the owner address 

	 select 
	  PARSENAME ( REPLACE ( ownerAddress , ',' , '.' ) , 3 )
	 ,PARSENAME ( REPLACE ( ownerAddress , ',' , '.' ) , 2 )
	 ,PARSENAME ( REPLACE ( ownerAddress , ',' , '.' ) , 1 )
	  from portfolioproject..NashvilleHousing
	
      ALTER Table PortfolioProject..NashvilleHousing 
	  add OwnerSplitAddress nvarchar (255) ; 

	  Update PortfolioProject..NashvilleHousing
	  set OwnerSplitAddress = PARSENAME ( REPLACE ( ownerAddress , ',' , '.' ) , 3 )

	  ALTER Table PortfolioProject..NashvilleHousing 
	  add OwnerSplitCity nvarchar (255 ) ; 

	  Update PortfolioProject..NashvilleHousing 
	  set OwnerSplitCity = PARSENAME ( REPLACE ( ownerAddress , ',' , '.' ) , 2 )

	  ALTER Table PortfolioProject..NashvilleHousing 
	  add OwnerSplitState nvarchar (255) ; 

	  Update PortfolioProject..NashvilleHousing 
	  set OwnerSplitState = PARSENAME ( REPLACE ( ownerAddress , ',' , '.' ) , 1 )

	  select * 
	  from PortfolioProject..NashvilleHousing

	  ------- Change Y and N to Yes and NO in "sold as vacant" filed 

	   select Distinct (soldasvacant ) , count ( soldasvacant )
	   from PortfolioProject..NashvilleHousing
	   group by SoldAsVacant
	   order by 2

	   select SoldAsVacant , 
	   case when SoldAsVacant = 'Y' then 'Yes' 
	        when SoldAsVacant = 'N' then  'No' 
	   Else SoldAsVacant
	   END
	   from PortfolioProject..NashvilleHousing

	   UPDATE PortfolioProject..NashvilleHousing 
	   set soldasvacant = case when SoldAsVacant = 'Y' then 'Yes' 
	        when SoldAsVacant = 'N' then  'No' 
	   Else SoldAsVacant
	   END
	   from PortfolioProject..NashvilleHousing

	   ------ Remove Duplicates 

       WITH RowNumCTE as (  
	   select * , 
	      row_number () over ( 
		  partition by parcelID ,
		               propertyAddress ,
					   SalePrice,
					   SaleDate ,
					   LegalReference 
					   order by UniqueID ) row_num
	      from PortfolioProject..NashvilleHousing )

		  select *
		  from RowNumCTE 
		  where row_num > 1 
		 order by PropertyAddress


		 ------- Delete Unused Columns 

		  ALTER Table PortfolioProject..NashvilleHousing
		  Drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate, PropertyCity

		  select * 
		  from PortfolioProject..NashvilleHousing

		  