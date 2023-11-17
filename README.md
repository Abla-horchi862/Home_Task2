# Home Task DataOps 2 Answers
## Technology Selection
First I demonstrate Source Data example that I choose for this task which is relational data with huge volume 41399 rows.
Data are stored in rows and columns, each row of the table has same columns.
Data that I choose is related to films specifications.

![datasource](https://github.com/Abla-horchi862/Home_Task2/assets/61522624/f98af0d0-5a86-4de7-91ba-ffdeb35ed92f)
           Figure1: screenshot of source Data

As showed in the photo columns types are various (integer, string, float…)
Columns of each film are :
#### filmtv_id: represents ID of each film.
#### Title: movie original title.
#### Year: movie year of release.
#### Genre: movie genre.
#### Duration: movie duration (in minutes).
#### Country: countries where the movie was filmed.
#### Directors: name of movie directors.
#### Actors: name of movie actors.
#### avg_vote: average rating, considering votes expressed by critics and the public.
#### critics_vote: average vote expressed by critics (if available).
#### public_vote: average vote expressed by the public (if available).
#### total_votes: total votes expressed by critics and the public.
#### description: movie description.
#### notes: movie notes.
#### humor: movie humor score given by filmtv.
#### rhythm: movie rhythm score given by filmtv.
#### effort: movie effort score given by filmtv.
#### tension: movie tension score given by filmtv.
#### erotism: movie erotism score given by filmtv.

In this task I’m going to tackle Big Data Pipeline which composed on four phases:
- Data Storage that could be on cloud or on promise.
- Data ingestion : extracting  data from multiple sources and store it in one place ( example Datawarehouse or dataLake).
- Data Processing: Data transforming and manipulation to make it more miningful.
- Data Visualization: using visualization tool to see transformed data and create reports.


![Data pipeline](https://github.com/Abla-horchi862/Home_Task2/assets/61522624/a616dd47-02fc-4dc9-b529-4ef46d55f622)

Figure 2: Big Data Pipeline

To achieve this pipeline in Azure as Cloud provider, I implement an architecture in which I've outlined leverages a mix of on-premise and Azure services to address various aspects of data storage, security, communication, data processing, and visualization. So I choose these components:
- Starting with on-premise I choose SQL Server for data storage that provides a familiar and robust relational database system. I add a firewall to enhance security, controlling access to the database and protecting sensitive information from unauthorized access.
- I include an IPSec VPN for communication between on-premise and Azure this ensures a secure and private connection. This is crucial for maintaining data integrity and confidentiality during the transfer of information between your local infrastructure and Azure services. The VPN establishes a reliable and encrypted connection, mitigating potential security risks associated with data in transit.
- For data ingestion I choose Azure Data Factory (ADF) and Azure Data Lake. ADF simplifies the process of orchestrating and automating data workflows, while Azure Data Lake provides scalable and secure storage for big data analytics. These services work seamlessly together, offering a robust solution for efficiently ingesting, preparing, and storing data at scale.
- For data processing I choose Azure Synapse Analytics (formerly SQL Data Warehouse) and Azure Databricks. Synapse Analytics provides a powerful analytics platform with on-demand scalability, allowing  to analyze large datasets efficiently. Databricks, on the other hand, is an ideal choice for big data processing and advanced analytics using machine learning models.
- I add a Virtual Network (VNet) that enhances the overall security of architecture by creating an isolated and private network within Azure. This ensures that resources are securely connected, and access can be tightly controlled, providing an additional layer of protection for data.
- I Integrate Power BI for visualization brings the data to life. Power BI's intuitive interface and powerful visualization capabilities allow for insightful reporting and analysis.
- I implement Azure Active Directory between Azure Synapse Analytics and Power BI ensures secure authentication and access control, aligning with best practices for identity management in the cloud.

## Data Platform Design
![azure architecture](https://github.com/Abla-horchi862/Home_Task2/assets/61522624/12f0e65e-178b-4f94-8bd5-d54df5e691bf)
Figure 3: Azure Architecture

### How this architecture works
Step 1: I store Relational table in SQL Server using SSMS tool and I ensure that firewall is active to secure data.
Step 2: Data is extracted and transited via IPSec VPN to ADF and Azure DataLake. In ADF I create pipeline to copy data from sql server to flat file (.csv file) also in ADF I adjusted source and destination, integration runtime to allow communication between azure VM and ADF also I adjusted linked service between SQL server and ADF, with these steps I can ensure well working of ADF pipeline. Also data is stored in DataLake to ensure fault tolerance.
Step 3: Flat Files which are output of ADF are used byAzure Synapse Analytics to apply transformation for data cleaning , normalization or optimization, Also data stored in Azure DataLake is used by Azure dataBricks as training data so use databricks notebook and python as programming language to developing a machine learning model to predict gendre of a film.
#### PS: For the prediction model I choose KMeans model.

Step 4: I rely power BI desktop to data released by Azure Synapse analytics to build some visualization to know more about films, actors and gendre…., also I implement Azure Active Directory to ensure authentication from Azure Synapse Analytics to Power BI.

## Infrastructure as Code IaC
You find above an attached .tf file in this project that includes Terraform script for building resources of the architecture
## Data Ingestion and Processing:
### I. Data ingestion workflow

![data ingestion workflow](https://github.com/Abla-horchi862/Home_Task2/assets/61522624/cb0d53c7-14f4-4e4f-8410-c48cc8b68281)
Figure 4: Big Data ingestion workFlow

Data is extracted and transited via IPSec VPN to ADF.
To transit data to ADF we follow these steps:
1. Create integration runtime in ADF to allow communication between local device and ADF
2. Adjust in ADF, source dataset (Table in sql server) and destination dataset(flat file) Dataset by creating linked service between SQL server and ADF
3. Create ADF pipeline to copy data from sql server to flat file using copy data function.

### II. Data processing
#### These are some screenshots from Azure Databricks Notebook
- This cell is about importing necessary labraries and opening location where data file is stored.
  ![1](https://github.com/Abla-horchi862/Home_Task2/assets/61522624/a9ad32f0-0fe8-4234-ab05-add3df9bae98)
- This cell is about reading and illustrating data.
  ![2](https://github.com/Abla-horchi862/Home_Task2/assets/61522624/9e57d1aa-1b3e-434e-bd7f-229007fb9789)

- This cell includes elbow method that calculates number of clusters for ML model.
  ![3](https://github.com/Abla-horchi862/Home_Task2/assets/61522624/d59bffdb-5696-44b4-81bf-898c18d0efc1)

- This cell includes running KMeans model for films' gendre prediction.
#### these are simple sql queries that i create in Azure Synapse Analytics 
1. Sql query to calculate number total of created films per year and country
SELECT Count(filmID) as Total_films  from filmTV_movie
GROUP BY
    Country, year;

2. SQL query to remove redundancy in table
SELECT DISTINCT *
FROMfilmTV_movie;

3. SQL query to add indexes to table column filmID to optimize the query and facilitate data retrieval.
-- Clustered index
CREATE CLUSTERED INDEX order
ON filmTV_movie (filmID);

