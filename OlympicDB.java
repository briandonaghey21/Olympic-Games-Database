import java.sql.*;
import java.time.LocalDateTime;
import java.util.Properties;
import java.util.Scanner;
  // TO COMPILE javac -cp postgresql-42.7.3.jar OlympicDB.java
  // TO RUN java -cp postgresql-42.7.3.jar:. OlympicDB.java , different on windows, see recitiation12
public class OlympicDB 
{
    Scanner scanner = new Scanner(System.in);
    private Connection conn;

    public void displayMenu()
    {
        System.out.println("\nChoose an operation: ");
        String menu = 
            "1:  createAccount            2:  removeAccount                          3:  addParticipant        \n" +
            "4:  removeParticipant        5:  addTeamMember                          6:  removeTeamMember      \n" +
            "7:  registerTeam             8:  addEvent                               9:  addTeamToEvent        \n" +
            "10: addEventOutcome          11: disqualifyTeam                         12: listVenuesInOlympiad  \n" +
            "13: listEventsOfOlympiad     14: listTeamsInEvent                       15: showPlacementsInEvent \n" +
            "16: listParticipantsOnTeam   17: listCountryPlacementsInOlympiad        18: listAthletePlacement  \n" +
            "19: countryRankings          20: mostSuccessfulParticipantsInOlympiad   21: topSports             \n" +
            "22: connectedCoaches         23: exit";
        System.out.println(menu);
        System.out.print("Enter your choice: ");
        int choice = 0;
        if (scanner == null || !scanner.hasNext())
            scanner = new Scanner(System.in); 
        choice = Integer.parseInt(scanner.nextLine());
            switch (choice) { 
                case 1:
                     createAccount();
                    break;
                case 2:
                     removeAccount();
                    break;
                case 3:
                    addParticipant();
                    break;
                case 4:
                    removeParticipant();
                    break;
                case 5:
                     addTeamMember();
                    break;
                case 6:
                    removeTeamMember();
                    break;
                case 7:
                    registerTeam();
                    break;
                case 8:
                     addEvent();
                    break;
                case 9:
                     addTeamToEvent();
                    break;
                case 10:
                     addEventOutcome();
                    break;
                case 11:   
                     disqualifyTeam();
                    break;
                case 12:
                     listVenuesInOlympiad();
                    break;
                case 13:
                     listEventsOfOlympiad();
                    break;
                case 14:
                     listTeamsInEvent();
                    break;
                case 15:
                     showPlacementsInEvent();
                    break;
                case 16:
                     listParticipantsOnTeam();
                    break;
                case 17:
                     listCountryPlacementsInOlympiad();
                    break;
                case 18:
                     listAthletePlacement();
                    break;
                case 19:
                    countryRankings();
                    break;
                case 20:
                    mostSuccessfulParticipantsInOlympiad();
                    break;
                case 21:
                    topSports();
                    break;
                case 22:
                    connectedCoaches();
                    break;
                case 23:  
                    exit();
                    break;
            }
    }
    
    // Connect to database with username and password
    public void connect() 
    {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException err) {
            System.err.println("Unable to detect the JDBC .jar dependency. Check that the library is correctly loaded in and try again.");
            System.exit(-1);
        }
        String url = "jdbc:postgresql://localhost:5432/";
        Properties props = new Properties();
        props.setProperty("user", "postgres");
        System.out.println("Enter your password: ");
        props.setProperty("password", scanner.nextLine());
       
        // Utilize Java try-with-resources to automatically close the connection and statement
        try {
            conn = DriverManager.getConnection(url, props);
            conn.setSchema("olympicdb");
            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE); // this makes our transactions serializable, prevents race conditions?
            System.out.println("Successfully connected to the database");
            
        } catch (SQLException e1) {
            // JDBC will throw a SQLException if errors occur on the database
            System.out.println("Failed to connect.");
            System.err.println("SQL Error");
            // Note that this returns an iterable of errors
            while (e1 != null) {
                System.err.println("Message = " + e1.getMessage());
                System.err.println("SQLState = " + e1.getSQLState());
                System.err.println("SQL Code = " + e1.getErrorCode());
                e1 = e1.getNextException();
            }
            System.exit(32);
        }
    }

    public boolean isConnected() {
        try {
            return !conn.isClosed();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void createAccount() 
    {
        System.out.print("Enter username: ");
        String username = scanner.nextLine();
        System.out.print("Enter passkey: ");
        String passkey = scanner.nextLine();
        System.out.print("Enter role (Organizer, Participant, Guest): ");
         String role = scanner.nextLine();
        Timestamp timestamp = Timestamp.valueOf(LocalDateTime.now()); 
    
        // call our function from sql, the brackets prevents sql injections
        try (CallableStatement stmt = conn.prepareCall("{ call createAccount(?, ?, ?::role_domain, ?) }")) {
            stmt.setString(1, username);
            stmt.setString(2, passkey);
            stmt.setString(3, role);
            stmt.setTimestamp(4, timestamp);
            stmt.execute();
            System.out.println("Account created successfully.");
            stmt.close();
        } catch (SQLException err)
         {
            System.out.println("Failed to createAccount() with username: " + username + " passkey: " + passkey +  "role: " + role);
            System.out.println("SQL Error:");
            while (err != null) { 
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
     }
    

    public void removeAccount() 
    {
        System.out.println("Enter account id to remove: ");
        int accountId = Integer.parseInt(scanner.nextLine());
        try (CallableStatement stmt = conn.prepareCall("{ call removeAccount( ? ) }")) {
            stmt.setInt(1, accountId);
            stmt.execute();
            System.out.println("Function executed successfully.");
            stmt.close();
        } catch (SQLException err) {
            System.out.println("Failed to removeAccount() with accountID " + accountId);
            System.out.println("SQL Error");
            while (err != null) {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }

    public void addParticipant() 
    {
        System.out.println("Enter account_id:");
        int accountId = Integer.parseInt(scanner.nextLine());
        System.out.println("Enter first name:");
        String fname = scanner.nextLine();
        System.out.println("Enter middle initial/middle name:");
        String mname = scanner.nextLine();
        System.out.println("Enter last name:");
        String lname = scanner.nextLine();
        System.out.println("Enter country of birth:");
        String country = scanner.nextLine();
        System.out.println("Enter gender: (M or F)");
        char gender = scanner.nextLine().charAt(0);
        Timestamp timestamp = Timestamp.valueOf(LocalDateTime.now()); 

        try (CallableStatement stmt = conn.prepareCall("{ call addParticipant( ?, ?, ?, ?, ?, ?, ? ) }")) {
            stmt.setInt(1, accountId);
            stmt.setString(2, fname);
            stmt.setString(3, mname);
            stmt.setString(4, lname);
            stmt.setString(5, country.toUpperCase());
            stmt.setTimestamp(6, timestamp);
            stmt.setString(7, String.valueOf(gender).toUpperCase()); 
            stmt.execute();
            System.out.println("Participant added successfully.");
            stmt.close();
        } catch (SQLException err) {
            System.out.println("Failed to addParticipant() with accountID: " + accountId + " first name: " + fname + " middle name: " + mname + " lastname: " + lname + " \ncountry: " + country + " gender: " + gender);
            System.out.println("SQL Error");
            while (err != null) {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }

    // Loops to get integer input
    private int requestInteger() {
        int choice;
        while (!scanner.hasNextInt()) {
            System.out.println("Please enter an integer.");
            scanner.nextLine();
        }
        choice = scanner.nextInt();
        scanner.nextLine();
        return choice;
    }

    public void removeParticipant() {
        while (true) {
            System.out.println("Would you like to remove all or selected participants from olympicDB? (all/selected)");
            String participantResponse = scanner.nextLine();
            if (participantResponse.toLowerCase().equals("all")) {
                while (true) {
                    System.out.println("Are you sure? (Yes/No)");
                    String response = scanner.nextLine();
                    if (response.toLowerCase().equals("yes"))
                    {
                        try {
                            PreparedStatement stmt = conn.prepareStatement("DELETE FROM team_members; DELETE FROM participant;");
                            stmt.execute();
                            System.out.println("Successfully removed all participants");
                            stmt.close();
                        } catch (SQLException err) {
                            System.out.println("Failed to remove all participants");
                            System.out.println("SQL Error");
                            while (err != null) {
                                System.out.println("Message = " + err.getMessage());
                                System.out.println("SQLState = " + err.getSQLState());
                                System.out.println("SQL Code = " + err.getErrorCode());
                                err = err.getNextException();
                            }
                        }
                        break;
                    } else if (response.toLowerCase().equals("no")) {
                        System.out.println("No participants were removed.");
                        break;
                    } else {
                        System.out.println("ERROR: Please input a proper response.");
                    }
                }
            } else if ( participantResponse.toLowerCase().equals("selected")) {
                try {
                    PreparedStatement stmt2 = conn.prepareStatement(
                        "SELECT * FROM PARTICIPANT",
                        ResultSet.TYPE_SCROLL_INSENSITIVE,
                        ResultSet.CONCUR_UPDATABLE // This allows for update and delete concurrency, although not inserts
                    );
                    stmt2.execute();
                    ResultSet rs = stmt2.getResultSet();
                    System.out.printf("\n%-14s  %-10s  %-20s  %-20s  %-20s  %-14s  %-9s %s\n",
                        "participant_id",
                        "account",
                        "first",
                        "middle",
                        "last",
                        "birth_country",
                        "dob", 
                        "gender"
                    );
                    System.out.println("------------------------------------------------------------------------------------------------------------------------------");
                    int curr_row = 0;
                    while (rs.next()) { // Iterate over participants
                        System.out.printf("%-14d  %-10d  %-20s  %-20s  %-20s  %-14s  %7$tm/%7$td/%7$tY %8$s\n",
                            rs.getInt("participant_id"),
                            rs.getInt("account"),
                            rs.getString("first"),
                            rs.getString("middle"),
                            rs.getString("last"),
                            rs.getString("birth_country"),
                            rs.getTimestamp("dob"),
                            rs.getString("gender")
                        );
                        curr_row = rs.getRow();
                        System.out.print("Enter the participant_id to confirm deletion. (0 for next, -1 to return to menu) ");
                        while (true) {
                            int choice = requestInteger();
                            if (choice == -1) {
                                return;
                            } else if (choice == 0) {
                                break;
                            } else {
                                boolean found = false;
                                rs.first();
                                do {
                                    int pid = rs.getInt("participant_id");
                                    if (pid == choice) {
                                        found = true;
                                    }
                                    if (rs.getRow() == curr_row) {
                                        break;
                                    }
                                } while (rs.next());
                                if (found) {
                                    CallableStatement stmt = conn.prepareCall("{ call removeParticipant( ? ) }");
                                    stmt.setInt(1, choice);
                                    stmt.execute();
                                    System.out.printf("Successfully removed participant %d\n", choice);
                                    stmt.close();
                                    break;
                                } else {
                                    System.out.println("Please enter a displayed participant_id, 0, -1.");
                                }
                            }
                        }
                    }
                    stmt2.close();
                } catch (SQLException err) {
                    System.out.println("Failed to remove a participant");
                    System.out.println("SQL Error");
                    while (err != null) {
                        System.out.println("Message = " + err.getMessage());
                        System.out.println("SQLState = " + err.getSQLState());
                        System.out.println("SQL Code = " + err.getErrorCode());
                        err = err.getNextException();
                    }
                }
                break;
            } else {
                System.out.println("ERROR: Please input a proper response.");
            }
        }
    }

    public void addTeamMember() {
        System.out.println("Enter participant_id: ");
        int participantId = Integer.parseInt(scanner.nextLine());
        System.out.println("Enter account_id: ");
        int accountId =Integer.parseInt(scanner.nextLine());

        try (CallableStatement stmt = conn.prepareCall("{ call addTeamMember( ?, ? ) }")) {
            stmt.setInt(1, participantId);
            stmt.setInt(2, accountId);
            stmt.execute();
            System.out.println("Team Member added successfully.");
            stmt.close();
        } catch (SQLException err) {
            System.out.println("Failed to addTeamMember() with participantID: " + participantId + "and accountID: " + accountId);
            System.out.println("SQL Error");
            while (err != null) {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }

    // Loops to get Yes/No response from user
    private boolean promptConfirmation() {
        String choice;
        while(true) {
            choice = scanner.nextLine();
            if (choice.toLowerCase().equals("yes")) {
                return true;
            } else if (choice.toLowerCase().equals("no")) {
                return false;
            } else {
                System.out.println("Please enter one of 'Yes' or 'No'.");
            }
        }
    }

    public void removeTeamMember() {
        System.out.println("Enter a team ID: ");
        int teamId = requestInteger();
        try {
            // Can't use listParticipantsOnTeam because that includes coach in results
            // This is basically just that w/o the union
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT * FROM PARTICIPANT WHERE participant_id IN (" +
                    "SELECT participant FROM TEAM_MEMBERS WHERE team = ?" +
                ") ORDER BY participant_id",
                ResultSet.TYPE_SCROLL_INSENSITIVE, // Gives me ability to do .previous() and loop backwards
                ResultSet.CONCUR_UPDATABLE // This allows for update and delete concurrency, although not inserts
            );
            stmt.setInt(1, teamId);
            stmt.execute();
            ResultSet rs = stmt.getResultSet();
            if (rs.next()) { // Check if result is empty
                System.out.printf("\n%-14s  %-10s  %-20s  %-20s  %-20s  %-14s  %-9s %s\n",
                    "participant_id",
                    "account",
                    "first",
                    "middle",
                    "last",
                    "birth_country",
                    "dob", 
                    "gender"
                );
                System.out.println("------------------------------------------------------------------------------------------------------------------------------");
                do {
                    int pid = rs.getInt("participant_id");
                    System.out.printf("%-14d  %-10d  %-20s  %-20s  %-20s  %-14s  %7$tm/%7$td/%7$tY %8$s\n",
                        pid,
                        rs.getInt("account"),
                        rs.getString("first"),
                        rs.getString("middle"),
                        rs.getString("last"),
                        rs.getString("birth_country"),
                        rs.getTimestamp("dob"),
                        rs.getString("gender")
                    );
                } while (rs.next());

                System.out.println("\nEnter the participant_id to remove (-1 to cancel): ");
                int removeId = requestInteger();
                if (removeId != -1) {
                    boolean found = false;
                    while (rs.previous()) {
                        int pid = rs.getInt("participant_id");
                        if (pid == removeId) {
                            found = true;
                            break;
                        }
                    }
                    if (found) {
                        System.out.printf("Are you sure you want to remove participant %d? (Yes/No)\n", removeId);
                        if (promptConfirmation()) {
                            CallableStatement stmt2 = conn.prepareCall("{ call removeTeamMember( ?, ? ) }");
                            stmt2.setInt(1, removeId);
                            stmt2.setInt(2, teamId);
                            stmt2.execute();
                            System.out.printf("Successfully removed participant %d from team %d\n", removeId, teamId);
                        } else {
                            System.out.printf("Cancelled removal of participant %d from team %d\n", removeId, teamId);
                        }
                    } else {
                        System.out.printf("There is no participant with ID %d on team %d\n", removeId, teamId);
                    }
                } else {
                    System.out.printf("Cancelled participant removal from team %d\n", teamId);
                }
            } else {
                System.out.println("No participants are currently members of the Team");
            }
        } catch (SQLException err) {
            System.out.println("SQL Error");
            while (err != null) {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }

    public void registerTeam() 
    {
        System.out.println("Enter olympiad number:");
        String olympiadId = scanner.nextLine();
        System.out.println("Enter sport_id:");
        int sportId = Integer.parseInt(scanner.nextLine());
        System.out.println("Enter coach_id:");
        int coachId = Integer.parseInt(scanner.nextLine());
        System.out.println("Enter country code: ");
        String countryCode = scanner.nextLine();
        System.out.println("Enter gender: (M, F, X)");
        char gender = scanner.nextLine().charAt(0);

        try (CallableStatement stmt = conn.prepareCall("{ call registerTeam( ?, ?, ?, ?, ? ) }")) {
            stmt.setString(1, olympiadId);
            stmt.setInt(2, sportId);
            stmt.setInt(3, coachId);
            stmt.setString(4, countryCode);
            stmt.setString(5, String.valueOf(gender)); 
            stmt.execute();
            System.out.println("Team Registered successfully.");
            stmt.close();
        } catch (SQLException err) {
            System.out.println("Failed to registerTeam() with olympiadID: " +olympiadId + " sportID: " +sportId + " coachID: " +coachId+ " Country Code: " + countryCode + " Gender: " + gender);
            System.out.println("SQL Error");
            while (err != null) {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }

    public void addEvent() {
        System.out.println("Enter venue name");
        String venueId = scanner.nextLine();
        System.out.println("Enter olympiad number:");
        String olympiadId = scanner.nextLine();
        System.out.println("Enter sport ID:");
        int sportId = Integer.parseInt(scanner.nextLine());
        System.out.println("Enter gender: (M, F, X)");
        char gender = scanner.nextLine().charAt(0);
        Timestamp timestamp = Timestamp.valueOf(LocalDateTime.now()); 


        try (CallableStatement stmt = conn.prepareCall("{ call addEvent( ?, ?, ?, ?, ? ) }")) {
            stmt.setString(1, venueId);
            stmt.setString(2, olympiadId);
            stmt.setInt(3, sportId);
            stmt.setString(4, String.valueOf(gender)); 
            stmt.setTimestamp(5, timestamp);
            stmt.execute();
            System.out.println("Event added successfully.");
            stmt.close();
        } catch (SQLException err) {
            System.out.println("Failed to addEvent() with venu name: " + venueId + " olympiad number: " + olympiadId + " sportID " + sportId + " gender: " + gender);
            System.out.println("SQL Error");
            while (err != null) {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }

    public void addTeamToEvent()
    {
        System.out.println("Enter event ID");
        int eventID = Integer.parseInt(scanner.nextLine());
        System.out.println("Enter team ID");
        int teamID = Integer.parseInt(scanner.nextLine());
        try (CallableStatement stmt = conn.prepareCall("{ call addTeamToEvent( ?, ? ) }")) 
        {
            stmt.setInt(1, eventID);
            stmt.setInt(2, teamID);
            stmt.execute();
            stmt.close();
            System.out.println("Team added to event successfully.");
        } catch (SQLException err) {
            System.out.println("Failed to addTeamToEvent() with eventID " + eventID + " teamID " + teamID);
            System.out.println("SQL Error");
            while (err != null) {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }

    public void addEventOutcome()
    {
        while (true)
        {
            System.out.println("Enter an eventID: ");
            int eventID = Integer.parseInt(scanner.nextLine());
            if (eventID == -1)
                break;
            System.out.println("Enter a teamID:");
            int teamID = Integer.parseInt(scanner.nextLine());
            System.out.println("Enter a position");
            int positionID = Integer.parseInt(scanner.nextLine());

            try (CallableStatement stmt = conn.prepareCall("{ call addEventOutcome( ?, ?, ? ) }")) 
            {
              stmt.setInt(1, eventID);
              stmt.setInt(2, teamID);
              stmt.setInt(3, positionID);
              stmt.execute();
              System.out.println("Added event outcome successfully.");
              stmt.close();
            }
            catch (SQLException err) 
            {
              System.out.println("Failed to addEventOutcome() with eventID " + eventID + " teamID " + teamID + " position " + positionID);
              System.out.println("SQL Error");
              while (err != null) 
              {
               System.out.println("Message = " + err.getMessage());
               System.out.println("SQLState = " + err.getSQLState());
               System.out.println("SQL Code = " + err.getErrorCode());
               err = err.getNextException();
              }
            }
        }
        System.out.println("Leaving addEventOutcome");
    }
       
    public void disqualifyTeam()
    {
         System.out.println("Enter team ID");
         int teamID = Integer.parseInt(scanner.nextLine());
         try (CallableStatement stmt = conn.prepareCall("{ call disqualifyTeam(?) }")) 
         {
            stmt.setInt(1, teamID);
            stmt.execute();
            System.out.println("Team disqualified successfully.");
            stmt.close();
         } catch (SQLException err)
         {
            System.out.println("Failed to disqualify teamID: " + teamID);
            System.out.println("SQL Error");
            while (err != null) {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }
       
       public void listVenuesInOlympiad()
       {
         System.out.println("Enter an olympiad number: ");
         String olympiadNumber = scanner.nextLine();
         try (CallableStatement stmt = conn.prepareCall("{ call ListVenuesInOlympiad(?) }"))
         {
            stmt.setString(1, olympiadNumber);
            stmt.execute();
            ResultSet result = stmt.executeQuery();
            if (!result.next())
                System.out.println("No results could be displayed for this olympiad number.");
            else
            {
                System.out.printf("\n%-30s |%10s\n", "Venue Name", "Capacity"); // -30 allow us to have an equal amount of spacing, same thing with -10
                System.out.println("-------------------------------------------");
                // String venueName = result.getString("venue_name");
                // int capacity = result.getInt("capacity");
                // System.out.printf("%-30s |%10d\n", venueName, capacity);
                do                
                {
                    String venueName = result.getString("venue_name");
                    int capacity = result.getInt("capacity");
                    System.out.printf("%-30s |%10d\n", venueName, capacity);
                } while (result.next());
                
            }
            stmt.close();
         }
         catch (SQLException err)
         {
            System.out.println("Failed to listVenuesInOlympiad() with olympiadNumber: " + olympiadNumber);
            System.out.println("SQL Error");
            while (err != null) 
            {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }
    
    public void listEventsOfOlympiad()   
    {
        System.out.println("Enter an olympiad number: ");
        String olympiadNumber = scanner.nextLine();
        try (CallableStatement stmt = conn.prepareCall("{ call listEventsOfOlympiad(?) }"))
         {
            stmt.setString(1, olympiadNumber);
            stmt.execute();
            ResultSet result = stmt.executeQuery();
            if (!result.next())
                System.out.println("No results could be displayed for this olympiad number.");
            else
            {
                System.out.printf("\n%10s | %-30s | %-30s | %5s | %6s | %s\n", "Event_id", "Venue", "Olympiad", "Sport", "Gender", "Date"); // -30 allow us to have an equal amount of spacing, same thing with -10
                System.out.println("--------------------------------------------------------------------------------------------------------------------------");
                do                
                {
                    int event = result.getInt("event_id");
                    String venue = result.getString("venue");
                    String olympiad = result.getString("olympiad");
                    int sport = result.getInt("sport");
                    String gender = result.getString("gender");
                    Timestamp date = result.getTimestamp("Date");
    
                    System.out.printf("%10d | %-30s | %-30s | %-5d | %-6s | %s\n", event, venue, olympiad, sport, gender, date);
                } while (result.next());

            }
            stmt.close();
         }
         catch (SQLException err)
         {
            System.out.println("Failed to listEventsOfOlympiad() with olympiad number: " + olympiadNumber);
            System.out.println("SQL Error");
            while (err != null) 
            {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }

      public void listTeamsInEvent()
      {
       System.out.println("Enter an event ID:");
       int event = Integer.parseInt(scanner.nextLine());
       try (CallableStatement stmt = conn.prepareCall("{ call listTeamsInEvent(?) }"))
         {
            stmt.setInt(1, event);
            stmt.execute();
            ResultSet result = stmt.executeQuery();
            if (!result.next())
                System.out.println("No results were found for this event id.");
            else
            {
                System.out.printf("\n%-7s | %-30s | %5s | %5s | %7s | %6s | %s\n", "team_id", "Olympiad", "Sport", "Coach", "Country", "Gender", "Eligible"); // -30 allow us to have an equal amount of spacing, same thing with -10
                System.out.println("---------------------------------------------------------------------------------------");
                do
                {
                    int team = result.getInt("team_id");
                    String olympiad = result.getString("olympiad");
                    int sport = result.getInt("sport");
                    int coach = result.getInt("coach");
                    String country = result.getString("country");
                    String gender = result.getString("gender");
                    boolean elligible = result.getBoolean("eligible");
                    System.out.printf("%-7d | %-30s | %5s | %5s | %7s | %6s | %s\n", team, olympiad, sport, coach, country,  gender, elligible);
                } while (result.next());
            }
            stmt.close();

         }
         catch (SQLException err)
         {
            System.out.println("Failed to listTeamsInEvent() with event ID " + event);
            System.out.println("SQL Error");
            while (err != null) 
            {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }
    
    public void showPlacementsInEvent()
    {
       System.out.println("Enter an event ID:");
       int event = Integer.parseInt(scanner.nextLine());
       try (CallableStatement stmt = conn.prepareCall("{ call showPlacementsInEvent(?) }"))
         {
            stmt.setInt(1, event);
            stmt.execute();
            ResultSet result = stmt.executeQuery();
            if (!result.next())
                System.out.println("No results were found for this event id.");
            else
            {
                System.out.printf("\n%-5s | %-4s | %-6s | %-2s \n", "Event", "Team", "Medal", "Position"); 
                System.out.println("--------------------------------");
                do
                {
                    int eventID = result.getInt("event");
                    int team = result.getInt("team");
                    String medal = result.getString("medal");
                    int position = result.getInt("Position");
                    System.out.printf("%-5d | %-4d | %-6s | %-5d \n", eventID, team, medal, position);
                } while (result.next());
            }
            stmt.close();
         }
         catch (SQLException err)
         {
            System.out.println("Failed to showPlacementsInEvent() with eventID " + event);
            System.out.println("SQL Error");
            while (err != null) 
            {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }

    public void listParticipantsOnTeam()
    {
       System.out.println("Enter a team ID:");
       int team = Integer.parseInt(scanner.nextLine());
       try (CallableStatement stmt = conn.prepareCall("{ call listParticipantsOnTeam(?) }"))
         {
            stmt.setInt(1, team);
            stmt.execute();
            ResultSet result = stmt.executeQuery();
            if (!result.next())
                System.out.println("No results were found for this team id.");
            else
            {
                System.out.printf("\n%-14s | %-7s | %30s | %30s | %30s | %13s | %20s  | %s\n", "participant_id", "Account", "First Name", "Middle Name", "Last Name", "Birth Country", "Dob", "gender"); // -30 allow us to have an equal amount of spacing, same thing with -10
                System.out.println("---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
                do
                {
                    int participant = result.getInt("participant_id");
                    String account = result.getString("account");
                    String first = result.getString("first");
                    String middle = result.getString("middle");
                    String last = result.getString("last");
                    String birth_country = result.getString("birth_country");
                    Timestamp dob = result.getTimestamp("dob");
                    String gender = result.getString("gender");
                    System.out.printf("%-14d | %-7s | %-30s | %-30s | %-30s | %-13s | %-20s | %s\n", participant, account, first, middle, last, birth_country, dob, gender);
                } while (result.next());
            }
            stmt.close();
         }
         catch (SQLException err)
         {
            System.out.println("SQL Error");
            while (err != null) 
            {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }

      public void listCountryPlacementsInOlympiad()
      {
        System.out.println("Enter a Country Code(ex. 'USA', 'CHN'):");
        String country = scanner.nextLine();    
        System.out.println("Enter an olympiad number");
        String olympiad = scanner.nextLine(); 
        try (CallableStatement stmt = conn.prepareCall("{ call listCountryPlacementsInOlympiad(?, ?) }"))
        {
            stmt.setString(1, country);
            stmt.setString(2, olympiad);
            stmt.execute();
            ResultSet result = stmt.executeQuery();
            if (!result.next())
                System.out.println("No results were found for this country and olympiad number.");
            else
            {
                System.out.printf("\n%-5s | %-4s | %-6s | %-2s \n", "Event", "Team", "Medal", "Position"); 
                System.out.println("--------------------------------");
                do
                {
                    int eventID = result.getInt("event");
                    int team = result.getInt("team");
                    String medal = result.getString("medal");
                    int position = result.getInt("Position");
                

                    System.out.printf("%-5d | %-4d | %-6s | %-5d \n", eventID, team, medal, position);
                } while (result.next());
            }
            stmt.close();
        }
        catch (SQLException err)
        {
            System.out.println("Failed to listCountryPlacementsInOlympiad() with country: " + country + " olympiad: " + olympiad);
            System.out.println("SQL Error");
            while (err != null) 
            {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }

    public void listAthletePlacement()
    {
        System.out.println("Enter a participant ID:");
        int participant = Integer.parseInt(scanner.nextLine());
        try (CallableStatement stmt = conn.prepareCall("{ call listAthletePLacement(?) }"))
          {
             stmt.setInt(1, participant);
             stmt.execute();
             ResultSet result = stmt.executeQuery();
             if (!result.next())
                System.out.println("No results were found for this participant id.");
            else
            {
                System.out.printf("\n%-5s | %-4s | %-6s | %-2s \n", "Event", "Team", "Medal", "Position"); 
                System.out.println("--------------------------------");
                do
                {
                    int eventID = result.getInt("event");
                    int team = result.getInt("team");
                    String medal = result.getString("medal");
                    int position = result.getInt("Position");
                    System.out.printf("%-5d | %-4d | %-6s | %-5d \n", eventID, team, medal, position);
                } while (result.next());
            }
            stmt.close();
          }
          catch (SQLException err)
          {
            System.out.println("Failed to listAthletePlacement() for participantID: " + participant);
             System.out.println("SQL Error");
             while (err != null) 
             {
                 System.out.println("Message = " + err.getMessage());
                 System.out.println("SQLState = " + err.getSQLState());
                 System.out.println("SQL Code = " + err.getErrorCode());
                 err = err.getNextException();
             }
        }
    }

    public void countryRankings() {
        // Scanner scanner = new Scanner(System.in);

        try (CallableStatement stmt = conn.prepareCall("{ call countryRankings() }")) {
            // stmt.registerOutParameter(1, Types.BIT);
            // stmt.setString(2, parameterValue);
            stmt.execute();
            
            ResultSet result = stmt.executeQuery();
            if (!result.next())
                System.out.println("No Countries to Rank.");
            else
            {
                String headerLine = String.format("%-20s |%30s |%10s |%10s", "Country Code", "Country Name", "Olympiad Count", "Participation Rank");

                System.out.println(headerLine);

                int headerLength = headerLine.length();

                StringBuilder dashedLineBuilder = new StringBuilder();
                for (int i = 0; i < headerLength; i++) {
                    dashedLineBuilder.append("-");
                }
                String dashedLine = dashedLineBuilder.toString();

                System.out.println(dashedLine);
                do
                {
                    String countryCode = result.getString("country_code");
                    String countryName = result.getString("country_name");
                    int count = result.getInt("olympiadCount");
                    int rank = result.getInt("participationRank");
               
                    System.out.printf("%-20s |%30s |%10d |%10d\n", countryCode, countryName, count, rank);
                } while (result.next());
            }
            stmt.close();
        } catch (SQLException err) {
            System.out.println("SQL Error");
            while (err != null) {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }

    public void mostSuccessfulParticipantsInOlympiad() {
        // Scanner scanner = new Scanner(System.in);

        System.out.println("Enter olympiad_num:");
        String olympiadNum = (scanner.nextLine());

        System.out.println("Enter number of athletes:");
        int k = Integer.parseInt(scanner.nextLine());

        try (CallableStatement stmt = conn.prepareCall("{call mostSuccessfulParticipantsInOlympiad( ?, ? ) }")) {
            stmt.setString(1, olympiadNum);
            stmt.setInt(2, k);
            stmt.execute();
            ResultSet result = stmt.executeQuery();
            if (!result.next())
                System.out.println("No results could be displayed for this olympiad number.");
            else
            {
                String headerLine = String.format("%-20s |%10s", "Participant ID", "Total Points");

                System.out.println(headerLine);

                int headerLength = headerLine.length();

                StringBuilder dashedLineBuilder = new StringBuilder();
                for (int i = 0; i < headerLength; i++) {
                    dashedLineBuilder.append("-");
                }
                String dashedLine = dashedLineBuilder.toString();

                System.out.println(dashedLine);
                do
                {
                    int id = result.getInt("participantID");
                    int points = result.getInt("total_points");
               
                    System.out.printf("%-20d |%10d\n", id, points);
                } while (result.next());
            }
            stmt.close();
        } catch (SQLException err) {
            System.out.println("SQL Error");
            while (err != null) {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }

    public void topSports() {
        // Scanner scanner = new Scanner(System.in);

        System.out.println("Enter x number of years to look through:");
        int x = Integer.parseInt(scanner.nextLine());

        System.out.println("Enter number of sports:");
        int k = Integer.parseInt(scanner.nextLine());

        try (CallableStatement stmt = conn.prepareCall("{call topSports( ?, ? ) }")) {
            stmt.setInt(1, x);
            stmt.setInt(2, k);
            stmt.execute();
            
            ResultSet result = stmt.executeQuery();
            if (!result.next())
                System.out.println("No results to display in the past " + x + " years.");
            else
            {
                String headerLine = String.format("%-10s |%30s |%10s", "Sport ID", "Sport Name", "Team Count");

                System.out.println(headerLine);

                int headerLength = headerLine.length();

                StringBuilder dashedLineBuilder = new StringBuilder();
                for (int i = 0; i < headerLength; i++) {
                    dashedLineBuilder.append("-");
                }
                String dashedLine = dashedLineBuilder.toString();

                System.out.println(dashedLine);
                do
                {
                    int id = result.getInt("sport_id");
                    String sport = result.getString("sport_name");
                    int count = result.getInt("teamCount");
               
                    System.out.printf("%-10d |%30s |%10d\n", id, sport, count);
                } while (result.next());
        
            }
            stmt.close();
        } catch (SQLException err) {
            System.out.println("SQL Error");
            while (err != null) {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }

    public void connectedCoaches() {
        // Scanner scanner = new Scanner(System.in);

        System.out.println("Enter 1st coach id:");
        int c1 = Integer.parseInt(scanner.nextLine());

        System.out.println("Enter 2nd coach id:");
        int c2 = Integer.parseInt(scanner.nextLine());

        try (CallableStatement stmt = conn.prepareCall("{? = call connectedCoaches( ?, ? ) }")) {
            stmt.registerOutParameter(1, Types.VARCHAR);

            stmt.setInt(2, c1);
            stmt.setInt(3, c2);
            stmt.execute();
            
            String connectionResult = stmt.getString(1);

            if (connectionResult == null || connectionResult.isEmpty() || connectionResult.contains("no path")) {
                System.out.println("No path was found");
            } else {
                System.out.println(connectionResult);
            }
            stmt.close();
        } catch (SQLException err) {
            System.out.println("SQL Error");
            while (err != null) {
                System.out.println("Message = " + err.getMessage());
                System.out.println("SQLState = " + err.getSQLState());
                System.out.println("SQL Code = " + err.getErrorCode());
                err = err.getNextException();
            }
        }
    }

    public void exit()
    {
        System.out.println("Closing scanner.");
        scanner.close();
        System.out.println("Closing connection to olympicDB.");
        try
        {
            conn.close();
        } catch (SQLException e) 
        {
            e.printStackTrace();
        }
        System.out.println("Exiting the system... Goodbye");
        System.exit(32);
    }

    public static void main(String[] args) 
    {
        OlympicDB olympicDB = new OlympicDB();
        olympicDB.connect();
        while (olympicDB.isConnected()) {
            olympicDB.displayMenu();
        }
    }
}
