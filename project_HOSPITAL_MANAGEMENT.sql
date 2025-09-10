
-- Doctors Table
CREATE TABLE Doctors (
    doctor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(100),
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Patients Table
CREATE TABLE Patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Visits / Appointments Table
CREATE TABLE Visits (
    visit_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES Patients(patient_id) ON DELETE CASCADE,
    doctor_id INT REFERENCES Doctors(doctor_id) ON DELETE SET NULL,
    visit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason VARCHAR(255),
    status VARCHAR(50) DEFAULT 'Scheduled' -- Scheduled, Completed, Cancelled
);

-- Bills Table
CREATE TABLE Bills (
    bill_id SERIAL PRIMARY KEY,
    visit_id INT REFERENCES Visits(visit_id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(50) DEFAULT 'Pending', -- Pending, Paid, Cancelled
    generated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert Doctors
INSERT INTO Doctors (first_name, last_name, specialization, phone, email) VALUES
('Rajesh', 'Sharma', 'Cardiologist', '9876543210', 'rajesh.sharma@hospital.com'),
('Neha', 'Verma', 'Dermatologist', '9876543211', 'neha.verma@hospital.com'),
('Anil', 'Kapoor', 'Orthopedic', '9876543212', 'anil.kapoor@hospital.com'),
('Priya', 'Singh', 'Gynecologist', '9876543213', 'priya.singh@hospital.com'),
('Vivek', 'Gupta', 'Neurologist', '9876543214', 'vivek.gupta@hospital.com');

-- Insert Patients
INSERT INTO Patients (first_name, last_name, dob, gender, phone, email) VALUES
('Amit', 'Kumar', '1990-05-15', 'Male', '9990001111', 'amit.kumar@gmail.com'),
('Pooja', 'Mehta', '1985-11-22', 'Female', '9990001112', 'pooja.mehta@gmail.com'),
('Suresh', 'Reddy', '1978-02-10', 'Male', '9990001113', 'suresh.reddy@gmail.com'),
('Anjali', 'Nair', '1995-07-19', 'Female', '9990001114', 'anjali.nair@gmail.com'),
('Ravi', 'Yadav', '2000-03-25', 'Male', '9990001115', 'ravi.yadav@gmail.com'),
('Sneha', 'Patel', '1992-09-09', 'Female', '9990001116', 'sneha.patel@gmail.com'),
('Deepak', 'Mishra', '1988-12-30', 'Male', '9990001117', 'deepak.mishra@gmail.com'),
('Meena', 'Iyer', '1993-06-05', 'Female', '9990001118', 'meena.iyer@gmail.com'),
('Karan', 'Thakur', '1997-04-12', 'Male', '9990001119', 'karan.thakur@gmail.com'),
('Ritu', 'Chopra', '1983-08-20', 'Female', '9990001120', 'ritu.chopra@gmail.com');

-- Insert Visits
INSERT INTO Visits (patient_id, doctor_id, visit_date, reason, status) VALUES
(1, 1, '2025-08-01 10:00:00', 'Chest pain', 'Completed'),
(2, 2, '2025-08-02 11:30:00', 'Skin allergy', 'Completed'),
(3, 3, '2025-08-03 09:15:00', 'Back pain', 'Scheduled'),
(4, 4, '2025-08-04 14:00:00', 'Pregnancy checkup', 'Completed'),
(5, 5, '2025-08-05 16:30:00', 'Headache', 'Cancelled'),
(6, 1, '2025-08-06 12:00:00', 'High BP', 'Scheduled'),
(7, 3, '2025-08-07 10:45:00', 'Knee pain', 'Completed'),
(8, 2, '2025-08-08 15:15:00', 'Acne treatment', 'Scheduled'),
(9, 4, '2025-08-09 11:00:00', 'Gyne exam', 'Completed'),
(10, 5, '2025-08-10 13:30:00', 'Migraines', 'Scheduled');

-- Insert Bills
INSERT INTO Bills (visit_id, amount, payment_status, generated_on) VALUES
(1, 1500.00, 'Paid', '2025-08-01'),
(2, 800.00, 'Paid', '2025-08-02'),
(3, 1200.00, 'Pending', '2025-08-03'),
(4, 2000.00, 'Paid', '2025-08-04'),
(5, 500.00, 'Cancelled', '2025-08-05'),
(6, 1000.00, 'Pending', '2025-08-06'),
(7, 2200.00, 'Paid', '2025-08-07'),
(8, 950.00, 'Pending', '2025-08-08'),
(9, 1700.00, 'Paid', '2025-08-09'),
(10, 1100.00, 'Pending', '2025-08-10');


---show all scheduled appointments
SELECT v.visit_id, 
       p.first_name || ' ' || p.last_name AS patient_name,
       d.first_name || ' ' || d.last_name AS doctor_name,
       v.visit_date, v.reason, v.status
FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
JOIN Doctors d ON v.doctor_id = d.doctor_id
WHERE v.status = 'Scheduled'
ORDER BY v.visit_date;


---Count appointments as per doctor
SELECT d.first_name || ' ' || d.last_name AS doctor_name,
       COUNT(v.visit_id) AS total_appointments
FROM Doctors d
LEFT JOIN Visits v ON d.doctor_id = v.doctor_id
GROUP BY doctor_name
ORDER BY total_appointments DESC;

--List appointments for a given patient
SELECT v.visit_id, v.visit_date, v.reason, v.status,
       d.first_name || ' ' || d.last_name AS doctor_name
FROM Visits v
JOIN Doctors d ON v.doctor_id = d.doctor_id
WHERE v.patient_id = 1
ORDER BY v.visit_date;

---Show all pending payment
SELECT b.bill_id, p.first_name || ' ' || p.last_name AS patient_name,
       d.first_name || ' ' || d.last_name AS doctor_name,
       b.amount, b.payment_status, b.generated_on
FROM Bills b
JOIN Visits v ON b.visit_id = v.visit_id
JOIN Patients p ON v.patient_id = p.patient_id
JOIN Doctors d ON v.doctor_id = d.doctor_id
WHERE b.payment_status = 'Pending'
ORDER BY b.generated_on;

--Total revenue collected(paid bill)
SELECT SUM(amount) AS total_revenue
FROM Bills
WHERE payment_status = 'Paid';

--Payment hostory for each patient
SELECT p.first_name || ' ' || p.last_name AS patient_name,
       COUNT(b.bill_id) AS total_bills,
       SUM(b.amount) FILTER (WHERE b.payment_status = 'Paid') AS total_paid,
       SUM(b.amount) FILTER (WHERE b.payment_status = 'Pending') AS total_pending
FROM Patients p
LEFT JOIN Visits v ON p.patient_id = v.patient_id
LEFT JOIN Bills b ON v.visit_id = b.visit_id
GROUP BY patient_name
ORDER BY total_paid DESC;

---remove null null
SELECT 
    p.first_name || ' ' || p.last_name AS patient_name,
    COUNT(b.bill_id) AS total_bills,
    COALESCE(SUM(b.amount) FILTER (WHERE b.payment_status = 'Paid'), 0) AS total_paid,
    COALESCE(SUM(b.amount) FILTER (WHERE b.payment_status = 'Pending'), 0) AS total_pending
FROM Patients p
LEFT JOIN Visits v ON p.patient_id = v.patient_id
LEFT JOIN Bills b ON v.visit_id = b.visit_id
GROUP BY patient_name
ORDER BY total_paid DESC;

-----stored procedure




------------------------------------stored procedure 


CREATE OR REPLACE FUNCTION generate_bill(p_visit_id INT)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_reason VARCHAR(255);
    v_amount DECIMAL(10,2);
    v_final_amount DECIMAL(10,2);
    v_exists INT;
BEGIN
    -- Visit reason fetch
    SELECT reason INTO v_reason
    FROM Visits
    WHERE visit_id = p_visit_id;

    IF NOT FOUND THEN
        RAISE NOTICE 'Visit ID % not found!', p_visit_id;
        RETURN NULL;
    END IF;

    -- Base fee
    v_amount := 500;

    -- Extra charges
    IF v_reason IS NULL THEN
        v_amount := v_amount + 700;
    ELSIF v_reason ILIKE '%chest pain%' OR v_reason ILIKE '%headache%' OR v_reason ILIKE '%migraines%' THEN
        v_amount := v_amount + 1000;
    ELSIF v_reason ILIKE '%skin allergy%' OR v_reason ILIKE '%acne%' THEN
        v_amount := v_amount + 500;
    ELSIF v_reason ILIKE '%pregnancy%' OR v_reason ILIKE '%gyne%' THEN
        v_amount := v_amount + 1500;
    ELSE
        v_amount := v_amount + 700;
    END IF;

    -- GST 10%
    v_final_amount := v_amount * 1.10;

    -- Insert or Update Bill
    SELECT COUNT(*) INTO v_exists
    FROM Bills
    WHERE visit_id = p_visit_id;

    IF v_exists > 0 THEN
        UPDATE Bills
        SET amount = v_final_amount,
            payment_status = 'Pending',
            generated_on = NOW()
        WHERE visit_id = p_visit_id;
    ELSE
        INSERT INTO Bills (visit_id, amount, payment_status, generated_on)
        VALUES (p_visit_id, v_final_amount, 'Pending', NOW());
    END IF;

    RETURN v_final_amount; 
END;
$$ LANGUAGE plpgsql;

-------------------------- --------------------
SELECT generate_bill(3);
--------------------------------------------------


-------------TRIGGER FOR PATIENT DISCHARGE--------------
--------------------------------------------------------
-- Step 1: Create function
CREATE OR REPLACE FUNCTION close_vision_payment()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.payment_status = 'Paid' THEN
        UPDATE Visits
        SET status = 'Closed'
        WHERE visit_id = NEW.visit_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 2: Create Trigger
CREATE TRIGGER trg_close_visit_on_payment
AFTER UPDATE OF payment_status ON Bills
FOR EACH ROW
EXECUTE FUNCTION close_visit_on_payment();

----HOW IT WORKS(WHEN DOCTOR DISCHARGE )
UPDATE Visits SET discharge_date = '2025-09-05' WHERE visit_id = 3;

-----WHEN PATIENT PAY THE BILL 
UPDATE Bills SET payment_status = 'Paid' WHERE bill_id = 5;


----------visit Report-------------
-----------------------------------
SELECT 
    v.visit_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    d.first_name || ' ' || d.last_name AS doctor_name,
    v.visit_date,
    v.reason,
    v.status AS visit_status,
    COALESCE(b.amount, 0) AS bill_amount,
    COALESCE(b.payment_status, 'Not Generated') AS payment_status,
    b.generated_on
FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
JOIN Doctors d ON v.doctor_id = d.doctor_id
LEFT JOIN Bills b ON v.visit_id = b.visit_id
ORDER BY v.visit_date;






