#The Problem
##How do you quickly report on data captures through many ActiveRecord associations?



#Consider this Data Model
![Rails Data model](/model.png)



## Create a Report of Feedback
    Feedback.all

## Must be valid
    def Feedback
      scope :filled out, -> where('text is not '' or )
    end

    Feedback.filled_out



## Filter by City
    ugly code to do this
query problems



Slow Queries = Bad for Web



#A Possible Solutioln
##Materialized Views



# Materialized Views
- Similar to a view but are persisted for impoved performance



    code of SQL statement
Significantly improved performance



# But this is a Rails talk!



# Migration
    code to create the materialized


# Model
A Materialized View can be treated just like any ohter table!
    code to create report model

# Tradeoffs
- Entire Materialized View must be refreshed at once
  - Bad for live data
  - "Roll you own" materialized view for this case
- Migrations are a pain
  - Entire Materialized View must be dropped and redefined for any changes to View or underlying Table
  - Reccomended to write in SQL (no scopes)