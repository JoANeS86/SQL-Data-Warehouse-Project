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

SOC: Separation Of Concerns, a software design principle that divides a system into distinct sections, where each section addresses a single, specific function or "concern".

For example, you won't be doing any business transformation in the Silver Layer, or any data cleansing in the Gold Layer: <ins>**Each Layer has it's own unique tasks**</ins>.
