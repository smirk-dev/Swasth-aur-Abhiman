🏃‍♂️ Sprint Planning: Swastha Aur Abhiman
==========================================

**Date:** December 26, 2025**Input:** PRD v1.1, Architecture TDD v1.0**Output:** Product Backlog & Sprint 1 Plan

Hello! I am your Scrum Master. I have taken the requirements from the PM and the technical structure from the Architect to create a prioritized **Product Backlog**.

I have organized the development into **4 Agile Sprints**. We will focus on getting the core infrastructure and "User/Admin" roles working first.

🎒 Product Backlog (Epics & Stories)
------------------------------------

### Epic 1: Foundation & Authentication (Sprint 1)

*   **Story 1.1:** Initialize Repo & Tech Stack (Flutter + NestJS + PostgreSQL).
    
*   **Story 1.2:** Implement Backend Database Schema (Users, Roles, Profiles).
    
*   **Story 1.3:** Create Universal Login Screen (UI) with Role Selector.
    
*   **Story 1.4:** Implement Admin Registration API (Create User, Doctor, Trainer, Teacher).
    
*   **Story 1.5:** Implement JWT Authentication & Role-Based Guards in NestJS.
    

### Epic 2: Admin Command Center (Sprint 2)

*   **Story 2.1:** Create Web Admin Dashboard UI (React/Flutter Web).
    
*   **Story 2.2:** Implement Media Upload API (S3 Integration) for 5 Domains (Health, Edu, Skills, etc.).
    
*   **Story 2.3:** Implement "Event" Creation Module.
    
*   **Story 2.4:** Integrate specific tagging for "Post-COVID" and specific Skill topics (Bamboo, Honeybee, etc.).
    

### Epic 3: User Core Experience (Sprint 3)

*   **Story 3.1:** Build User Home Screen with Navigation Drawer (Medical, Edu, Skills, Nutrition, Events).
    
*   **Story 3.2:** Implement "Medical" Tab: BP/Sugar tracking UI + Charts.
    
*   **Story 3.3:** Implement Prescription Upload (Camera/Gallery -> S3 Secure Bucket).
    
*   **Story 3.4:** Implement Education Hub: Class 1-12 NCERT PDF Viewer.
    

### Epic 4: Communication & Professional Views (Sprint 4)

*   **Story 4.1:** Setup Socket.io Gateway for Real-Time Chat.
    
*   **Story 4.2:** Build Chat UI (User ↔ Doctor/Teacher/Trainer).
    
*   **Story 4.3:** Build Doctor Dashboard (View Patient Prescriptions).
    
*   **Story 4.4:** Build Video Streaming Player (HLS) for Training/Nutrition content.
    

🚀 Sprint 1: The "Genesis" Sprint
---------------------------------

**Goal:** Establish the database, API foundation, and allow Users/Admins to log in.

**Selected Tasks for Developer (\*agent dev):**

1.  **\[Backend\]** Setup NestJS project with TypeORM and PostgreSQL connection.
    
2.  **\[Backend\]** Create User entity with Enum Roles (ADMIN, USER, DOCTOR, TEACHER, TRAINER).
    
3.  **\[Backend\]** Create Auth Controller (/auth/login, /auth/register) with JWT generation.
    
4.  **\[Frontend\]** Setup Flutter Project with Riverpod.
    
5.  **\[Frontend\]** Build Login Screen (matches "Figure 1" from manual) with Role Buttons.
    
6.  **\[Frontend\]** Build "Register User" Screen (matches "Figure 3-6") with Block Selection (Vikasnagar, etc.).