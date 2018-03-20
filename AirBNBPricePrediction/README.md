# AirBnB Price Predictions

## Business Acumen
As we know, AirBnB is a marketplace for short term rentals that allows to list part or all of your living space for others to rent. Because most of the listings are on a short-term basis, AirBnB has grown to become a popular alternative to hotels. 

One challenge that hosts looking to rent their living space face is determining the optimal nightly rent price. In many areas, renters are presented with a good selection of listings and can filter on criteria like price, number of bedrooms, room type and more. Since AirBnB is a marketplace, the amount a host can charge on a nightly basis is closely linked to the dynamics of the marketplace. As a host, if one tries to put the tariff above market price , then renters will select more affordable similar alternatives. On the other hand, if one sets nightly rent price too low, one will miss out on potential revenue.**We will try to solve this problem by predicting the optimum price for AirBnB listings in Washington DC area.**

## Highlights:
- Data Preprocessing
- Data Cleaning
- Imputation of missing data
- HyperParameter optimization
- kFold cross validation
- Outlier Analysis
- Regression techniques used: Linear, knn, Decision Tree and Random Forest
- Root Mean Squared Error reduced to half after applying multiple modelling techniques

## Dataset Description
While AirBnB doesn't release any data on the listings in their marketplace, a separate group named [Inside AirBnB](http://insideairbnb.com/get-the-data.html) has extracted data on a sample of the listings for many of the major cities on the website. The raw dataset used in this predictive modelling has been downloaded from [here](http://data.insideairbnb.com/united-states/dc/washington-dc/2017-05-10/data/listings.csv.gz).  

## Attribute Information:

The raw dataset has 95 features some of which are mentioned below:

- host_response_rate: the response rate of the host
- host_acceptance_rate: number of requests to the host that convert to rentals
- host_listings_count: number of other listings the host has
- latitude: latitude dimension of the geographic coordinates
- longitude: longitude part of the coordinates
- city: the city the living space resides
- zipcode: the zip code the living space resides
- state: the state the living space resides
- accommodates: the number of guests the rental can accommodate
- room_type: the type of living space (Private room, Shared room or Entire home/apt
- bedrooms: number of bedrooms included in the rental
- bathrooms: number of bathrooms included in the rental
- beds: number of beds included in the rental
- price: nightly price for the rental
- cleaning_fee: additional fee used for cleaning the living space after the guest leaves
- security_deposit: refundable security deposit, in case of damages
- minimum_nights: minimum number of nights a guest can stay for the rental
- maximum_nights: maximum number of nights a guest can stay for the rental
- number_of_reviews: number of reviews that previous guests have left
- cancellation_policy



