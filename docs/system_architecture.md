🏗️ System Architecture & Tech Stack: Swastha Aur Abhiman
=========================================================

**Date:** December 26, 2025**Project:** Swastha Aur Abhiman (Government Health & Education App)**Input:** PRD v1.1**Output:** Technical Design Document (TDD) v1.0

1\. High-Level Architecture
---------------------------

We will utilize a **Client-Server Architecture** with a mobile-first approach. Given the requirements for video streaming, real-time chat, and role-based data access, the system requires a robust backend API and a scalable file storage solution.

### 1.1 Diagram: System Overview

Mobile App (Flutter) ↔ API Gateway (Node.js) ↔ Core Services ↔ Database (PostgreSQL)↕Object Storage (S3/MinIO)

2\. Technology Stack Selection
------------------------------

### 2.1 Frontend (Mobile App)

*   **Framework:** **Flutter (Dart)**
    
    *   _Why:_ Single codebase for Android & iOS (critical for government reach). Excellent performance on low-end devices. Good support for offline data caching.
        
*   **State Management:** Riverpod or BLoC.
    
*   **Local Database:** Hive (for caching NCERT books/offline video metadata).
    

### 2.2 Backend (API)

*   **Runtime:** **Node.js** with **NestJS Framework**.
    
    *   _Why:_ Strongly typed (TypeScript), scalable, and excellent support for WebSocket (needed for the "Universal Chat" feature).
        
*   **Admin Panel:** **React Admin** or a custom **React** dashboard connecting to the Node.js API.
    
    *   _Why:_ The Admin needs complex controls (content management across 5 domains, user approval). A dedicated Web Dashboard is superior to managing this on mobile.
        

### 2.3 Database & Storage

*   **Primary DB:** **PostgreSQL**.
    
    *   _Why:_ Relational data integrity is crucial for handling 5 distinct roles and their relationships (e.g., Doctor ↔ Prescription ↔ Patient).
        
*   **File Storage:** **AWS S3** (or generic S3-compatible storage like MinIO for on-premise government hosting).
    
    *   _Content:_ Prescriptions (secure), Videos (stream optimized).
        

### 2.4 Real-Time Communication

*   **Protocol:** **WebSockets (Socket.io)**.
    
    *   _Use Case:_ Instant messaging between Users, Doctors, Teachers, and Trainers.
        

3\. Database Schema Design (ERD Concept)
----------------------------------------

To support the PRD v1.1 requirements, we need a normalized schema.

### 3.1 Core Identity

*   **Users Table:**
    
    *   id (UUID)
        
    *   email (Unique)
        
    *   password\_hash
        
    *   role (Enum: ADMIN, USER, DOCTOR, TEACHER, TRAINER)
        
    *   full\_name
        
    *   gender
        
    *   is\_active (Boolean - for Admin approval)
        
    *   created\_at
        

### 3.2 Role-Specific Profiles (1:1 Relationships)

*   **User\_Profiles:**
    
    *   user\_id (FK)
        
    *   block (Enum: Vikasnagar, Doiwala, Sahaspur)
        
    *   health\_metrics (JSONB: { bp\_history, sugar\_history, bmi\_history })
        
*   **Doctor\_Profiles:**
    
    *   user\_id (FK)
        
    *   specialization (String)
        
    *   verification\_status
        

### 3.3 Content Management (Admin Controlled)

*   **Media\_Content Table:**
    
    *   id
        
    *   title
        
    *   description
        
    *   category (Enum: MEDICAL, EDUCATION, SKILL, NUTRITION)
        
    *   sub\_category (e.g., "Post-COVID", "Bamboo Training", "Class 5 NCERT")
        
    *   media\_url (S3 Link)
        
    *   uploaded\_by (Admin ID)
        
*   **Events Table:**
    
    *   id
        
    *   title
        
    *   date\_time
        
    *   location
        
    *   description
        

### 3.4 Medical Data

*   **Prescriptions Table:**
    
    *   id
        
    *   user\_id (Uploader)
        
    *   image\_url
        
    *   description (Symptoms/Notes)
        
    *   status (Enum: PENDING, REVIEWED)
        

### 3.5 Communication

*   **Chat\_Rooms Table:**
    
    *   id
        
    *   participant\_ids (Array of User IDs)
        
    *   type (Direct/Group)
        
*   **Messages Table:**
    
    *   room\_id
        
    *   sender\_id
        
    *   content (Text/Image)
        
    *   timestamp
        

4\. Key Implementation Strategy
-------------------------------

1.  **Role-Based Access Control (RBAC):** Middleware in NestJS using Guards to ensure, for example, only Admins can POST to /media endpoints, but all roles can GET based on their scope.
    
2.  **Video Streaming:** Implementation of HLS (HTTP Live Streaming) is recommended for low-bandwidth rural areas, rather than direct MP4 downloads.
    
3.  **Data Privacy:** Prescriptions must be stored in a private S3 bucket with signed URLs generated only for the uploading User and verified Doctors.