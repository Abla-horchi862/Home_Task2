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
