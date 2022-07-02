# Introduction

This is an IOS assignment developed with Swift language.

# Features

The IOS app lets tutors give marks to each student in different marking schemes, review weekly summaries, and manage students' information.

# Files

- Module
  - MarkingScheme.swift
    > MarkingScheme object
  - Student.swift
    > Student object
- StudentList
  - StudentListViewController.swift & StudentListTableViewCell.swift
    > Users can see all students and search particular students in a table view, and can share all students' scores and add new students   
  - StudentDetailViewController.swift & StudentTableViewCell.swift
    >  Users can review and update students' details and delete students
  - AddStudentViewController.swift
    > Users can add new students with student's information and photo
- WeeklySummary
  - WeeklySummaryViewController.swift & WeeklySummaryTableViewCell.swift
    > Users can review all students' scores and an average score of all students of each week in a table view
- Marking
  - MarkingStudentViewController.swift & MarkingStudentTableViewCell.swift
    > Users can mark students with different types of marking schemes (Attendance, Multiple Checkpoints, Score out of X, Grade Level (HD or A))  in a table view
- TabBarViewController.swift
  > Marking, student list, and weekly summary panels will displayed in the tab view