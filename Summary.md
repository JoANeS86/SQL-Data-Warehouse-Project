**<ins>Data Warehouse</ins>**: A subject-oriented, integrated, time-variant, and non-volatile collection of data in support of management's decision-making process.

<p align="center">
  <img src="https://github.com/user-attachments/assets/86b9a50f-8e76-4b0b-a6db-51341bdf549b" />
</p>

# <p align="center">ETL</p>


<p align="center">
  <img src="https://github.com/user-attachments/assets/fb709627-2667-44ea-a418-e843cf32b309" />
</p>

**Data Architecture Design**

Analyze requirements, choose the right approach (Medallion Approach in this case) and design the layers of DWH.

<ins>SOC</ins>: Separation Of Concerns, a software design principle that divides a system into distinct sections, where each section addresses a single, specific function or "concern".

For example, you won't be doing any business transformation in the Silver Layer, or any data cleansing in the Gold Layer: <ins>**Each Layer has it's own unique tasks**</ins>.<br/><br/>

**Project Settings**

Define <ins>**Naming Convention**</ins>: Set of Rules or Guidelines for naming anything in the project (Database, Schema, Tables, Store Procedures...).

Deciding a Naming Convention:

<p align="center">
  <img src="https://github.com/user-attachments/assets/1e44c051-6454-4314-b68f-9f0881c84b73" />
</p>

After deciding the Naming Convention, it would be recommended to also decide the Language that's gonna be used, as well as specifying the reserved words that should be avoided (e.g., do not use SQL reserved words as object names).

It's recommendable to create a document explaining the Naming Convention (for tables, columns...).

Create Database and Schemas









