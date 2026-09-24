# EduTrack

EduTrack is a **role-aware Flutter academic tracking and management application** designed for university students and teachers.

It brings essential academic workflows into a single mobile platform, including **course management, attendance tracking, continuous assessment (CT) marks, academic performance insights, routines, reports, alerts, announcements, and AI-assisted academic search**.

The application provides separate experiences for **Students** and **Teachers**, with role-based workflows and authorization throughout the system.

---

## Core Capabilities

EduTrack focuses on the core academic workflows that students and teachers interact with throughout a semester.

- Course and enrollment management
- Continuous assessment (CT) marks
- Academic performance tracking and insights
- Attendance recording and history
- Attendance-risk analysis
- Class routines and schedules
- CT alerts and reminders
- Course-scoped announcements
- Course statistics and reports
- AI-assisted academic search and insights
- Student academic dashboard
- Teacher management dashboard
- Student and teacher profiles
- Academic report export
- Text-to-speech support for academic results

---

## Student Features

EduTrack provides students with a centralized view of their academic activities and progress.

### Student Dashboard

The student dashboard provides an overview of:

- Today's classes
- Weekly schedule
- Upcoming classes
- Upcoming CTs
- Attendance information
- Academic statistics
- Academic insights
- CT reminders
- Quick access to important academic features

### Courses

Students can:

- View enrolled courses
- View course details
- Check course statistics
- View attendance information
- View CT marks
- Review academic performance
- View attendance-risk information
- Access course announcements

### Attendance

Students can access:

- Overall attendance percentage
- Course-level attendance
- Attendance history
- Individual attendance sessions
- Attendance summaries
- Attendance-risk information

Attendance data is scoped to the authenticated student and their enrolled courses.

### CT Marks

Students can:

- View CT marks
- Review individual CT results
- View course-level CT performance
- Track academic performance
- Receive performance insights

### Academic Performance Insights

EduTrack provides AI-assisted academic insights based on structured academic data.

Insights can help summarize information such as:

- Course performance
- CT performance
- Attendance patterns
- Academic progress
- Areas that may require attention

### Routine Management

Students can create and manage their personal academic routines.

This includes:

- Class schedules
- Routine days
- Course schedules
- Recurring academic activities

### Academic Search

Students can search their academic information using natural-language queries.

Examples include queries about:

- Courses
- Attendance
- CT marks
- Routines
- Academic performance

Search requests are converted into structured queries and validated before accessing application data.

---

## Teacher Features

The teacher experience focuses on managing courses, students, attendance, assessments, and academic reports.

### Teacher Dashboard

The teacher dashboard provides:

- Course statistics
- Student statistics
- Today's classes
- Course progress
- Attendance information
- CT activities
- Quick actions
- AI-assisted insights

### Course Management

Teachers can:

- Create courses
- View courses
- View course details
- Assign students
- Manage enrolled students
- View course statistics
- Manage course-related academic data

Teacher access is associated with the `teacherId` relationship of a course.

### Attendance Management

Teachers can:

- Take attendance
- View attendance history
- View course attendance statistics
- Review individual student attendance
- Identify attendance-risk students

### CT Marks Management

Teachers can manage continuous assessment through workflows for:

- Uploading CT marks
- Previewing marks
- Editing marks
- Reviewing CT details
- Publishing CT results
- Viewing student CT performance

### Attendance Risk

Teachers can view students who may require attention based on attendance data and configured attendance thresholds.

### Course Reports

Teachers can generate structured course reports containing academic information such as:

- Student performance
- Attendance
- CT results
- Course statistics

Reports can be exported for further use.

### CT Alerts and Reminders

Teachers can create CT-related alerts and reminders for their courses to communicate important assessment activities to students.

### Teacher Search

Teachers can search academic information related to:

- Courses
- Students
- Attendance
- CT marks
- Academic data

---

## AI-Assisted Features

AI is used as an **assistance and interpretation layer**, rather than as an unrestricted source of application data or business logic.

EduTrack uses AI for:

- Natural-language academic search
- Structured query interpretation
- Attendance-risk classification
- Academic performance insights
- Personalized CT reminders
- Structured course reports
- Student academic insights
- Teacher academic insights

### AI Data Flow

```text
User Query
    |
    v
AI Service / Proxy
    |
    v
Structured AI Response
    |
    v
Flutter Validation
    |
    +-- Authenticated User
    +-- User Role
    +-- Course Authorization
    +-- Query Validation
    |
    v
Existing Repositories
    |
    v
Firestore
