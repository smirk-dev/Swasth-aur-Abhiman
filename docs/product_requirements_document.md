📋 Product Requirements Document (PRD)
======================================

**Project Name:** Swastha Aur Abhiman**Version:** 1.1 (Revised)**Date:** December 26, 2025

1\. Introduction & Goals
------------------------

The goal is to build a comprehensive digital ecosystem that bridges the gap between citizens (applicants) and essential services. This system is designed to decentralize access to medical advice, educational resources, and training materials.**Content Strategy Note:** All health and nutrition content will emphasize **Post-COVID recovery** and traditional knowledge, specifically the use of herbs and plants for common ailments (e.g., treating anemia in women).

2\. User Personas
-----------------

1.  **Admin:** Super-user responsible for system management and onboarding.
    
2.  **User (Applicant):** The primary beneficiary (Citizen/Patient).
    
3.  **Doctor:** Medical professional.
    
4.  **Trainer:** Skill development expert (Artisan/Vocational).
    
5.  **Teacher:** Educational guide (K-12).
    

3\. Functional Requirements & User Stories
------------------------------------------

### 3.1 Module: Authentication & Role Management

*   **Story 1.1 (Login):** As a user (any role), I must be able to log in using my credentials and select my role.
    
*   **Story 1.2 (Admin - Registration):** As an Admin, I want to register new Users, Doctors, Trainers, and Teachers.
    

### 3.2 Module: Admin Dashboard

*   **Story 2.1 (Global Content Management):** As an Admin, I want to upload videos and content for **all domains of the app** (Medical, Education, Skills, Nutrition, Events) so I have complete control over the information displayed to users.
    
*   **Story 2.2 (Data Monitoring):** As an Admin, I want to view uploaded data and user statistics.
    

### 3.3 Module: User (Citizen) Features

*   **Story 3.1 (Medical Dashboard):** As a User, I want to track health metrics and view doctors.
    
    *   _Constraint:_ Content must include general information on herbal remedies (e.g., plants for anemia).
        
*   **Story 3.2 (Prescription Upload):** As a User, I want to upload prescriptions via photo/gallery.
    
*   **Story 3.3 (Education Hub):** As a User, I want to access NCERT books for **Classes 1 through 12** and curated educational videos.
    
*   **Story 3.4 (Skill Development):** As a User, I want to access vocational training videos.
    
    *   _Specific Topics:_ **Bamboo training, Artisan training, Honeybee farming, Jutework, and Macrame work.**
        
*   **Story 3.5 (Nutrition):** As a User, I want to view diet videos, including specific **Post-COVID diet tips** and general wellness advice.
    
*   **Story 3.6 (Events):** As a User, I want to view upcoming community events.
    

### 3.4 Module: Universal Communication (Chat)

*   **Story 4.1 (Inter-Role Chat):** As a non-admin user (User, Doctor, Teacher, Trainer), I want to initiate and participate in chats with **any other non-admin role**.
    
    *   _Scope:_ User ↔ Doctor, User ↔ Teacher, User ↔ Trainer, Doctor ↔ Teacher, Doctor ↔ Trainer, Teacher ↔ Trainer.
        
    *   _Exclusion:_ Admin does not participate in chats.
        

### 3.5 Module: Doctor, Teacher, Trainer Features

*   **Story 5.1 (Patient Review - Doctor):** View uploaded prescriptions.
    
*   **Story 5.2 (Resource Access):** Access domain-specific content (Health/Nutrition for Doctors; Education for Teachers).