# Hospital-management-

# 🏥 Hospital Management Database

A simple **Hospital Management Database** built using **PostgreSQL**.  
This project helps in managing **patients, doctors, visits, and billing records** efficiently.

---

## 📖 Features
- Manage **Patient Records**  
- Manage **Doctor Details**  
- Track **Appointments / Visits**  
- Handle **Billing (Paid, Pending, Partial)**  
- Triggers for **auto status updates**  
- Reports for **visits and payments**

---

## 🛠️ Tools Used
- **PostgreSQL**
- **pgAdmin**
- **SQL (DDL, DML, Triggers, Procedures)**

---

## 📂 Project Structure

hospital-management-database/
│
├── sql/
│ ├── schema.sql # Database tables
│ ├── sample_data.sql # Insert sample records
│ ├── procedures.sql # Stored procedures
│ ├── triggers.sql # Triggers
│ └── reports.sql # Queries for reports
│
├── docs/
│ └── Hospital_Management_Database_Report.pdf # Project report
│
├── images/
│ ├── schema.png # ER diagram / schema screenshot
│ └── report.png # Sample report screenshot
│
└── README.md # Project documentation


---

---

## 🚀 How to Run
1. Clone this repository:
   ```bash
   git clone https://github.com/Technoneha/Hospital-management-/
   cd hospital-management-database/sql


   -- Show all upcoming appointments
SELECT v.visit_id, p.first_name || ' ' || p.last_name AS patient,
       d.first_name || ' ' || d.last_name AS doctor,
       v.visit_date, v.status
FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
JOIN Doctors d ON v.doctor_id = d.doctor_id
WHERE v.status = 'Scheduled';

-- Show total paid & pending bills
SELECT SUM(paid) AS total_paid, SUM(pending) AS total_pending
FROM Bills;
📌 Future Improvements

Add authentication system

Create a frontend (React/Vue) for doctors & patients

Integrate with Python Flask/Django API

👩‍💻 Author

Neha Mishra
MSc IT | Data Analytics & Web Development Enthusiast
✨ "Chasing stars, learning from shadows, and living for moments that take my breath away" ✨
----
