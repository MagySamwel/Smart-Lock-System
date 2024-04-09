/*
                    ** How do we store and retrieve from EEPROM?? **



   * How do we store IDs and PCs in EEPROM ?
    -given that the id ranges (0 >> 999 ) ,  so we only need 10 bits for them (2 bytes)
     and the PC ranges (0 >> 999 ) , so we only need 10 bits for them (2 bytes)
    -for the second byte :
       we use it to store the number (first 8 bits of it) in.
    -for the first byte :
       bits number (6,7) >> we use them for the flag.
       the first 2 bits(0,1) >> we use them to complete the number (as it needs 10 bits)

                     -------------------------------
   * How do we store names in EEPROM ?
    - we made a byte for each name :
        bits number (6,7) >> we use them for the flag.
        the other 6 bits >> we use them to indicate the length of the name to help us while searching queries.

                      ------------------------------
   *Flag (last two bits (6,7) of the target byte) description:
    - 01 >> indicates that it's an ID.
    - 10 >> indicates that it's a PC.
    - 11 >> indicates that it's a name.
    - The flag helps us in searching queries.
                      ------------------------------
    *The benefits of this method:
     - in the normal way :
       - we store each number (ID,PC) as characters so we need 3 bytes for each.
       - we have to traverse on all characters of any name to get the next ID.

     - in our method :
         - we save 2 bytes for each person (1 from ID and 1 from PC)
         - it's more easy to search for a name since we have its length.
         - It's also faster. For instance, when searching for a specific ID,
            we can skip names easily without the need to traverse their characters,
            thanks to the stored length information. This optimization speeds up the search process.


*/
#include <mega16.h>
#include <alcd.h>
#include <delay.h>
#include <stdbool.h>
#include <string.h>

// Initialization Functions
void initialize_pins();
void enter_samples();
void wait_asterisk();


// User interaction and data operations 
void mainPage();
unsigned int read_lcd();
unsigned char keypad();
bool match_ID_PC(unsigned int id, unsigned int entered_passward);
void set_passcode();
void update_password(unsigned id);
unsigned int get_passward(unsigned int id);
void admin_update_password(unsigned int id, unsigned int new_passward);
char* get_name(unsigned int id);
bool exist(unsigned id);
int get_id_location(unsigned int id);
unsigned int check_flags(unsigned char curr_char);
unsigned int get_nameLength(unsigned char ch);
void admin_interaction();
void handle_interrupt(bool check_password);

// EEPROM Storage and Retrieval Functions 
void EE_Write(unsigned int address, unsigned char data);
unsigned char EE_Read(unsigned int address);
unsigned int store(char name[], unsigned int id, unsigned int password, unsigned int location);
unsigned int store_number(unsigned int number, unsigned int location, bool ID_or_PC);
unsigned int store_name(char name[], unsigned int location);
unsigned int get_number(unsigned int location);
char* get_name_fromEEPROM(unsigned int location);

// Error functions 
void error(int number_of_peeps, const char* message);

// Bitwise manipulation 
unsigned int GetBit(unsigned int num, unsigned int idx);
unsigned int SetBit1(unsigned int num, unsigned int idx);
unsigned int SetBit0(unsigned int num, unsigned int idx);

// Motor control functions 
void open_door();
void close_door();

// Interrupt Service Routines 
interrupt[2] void admin_INT0(void);
interrupt[3] void setPC_INT1(void);

// Global variables 
unsigned char c = '\0';     
unsigned int curr_location = 0 ;  // indicates the current address at EEPROM
unsigned int curr_num=-1;         
bool first_run = true;      // check running the programe for the first time 
bool enter_password=false;  // indicates the password mode (check that the user enters password or ID )
bool run_interrupt=false;   // check the starting of the interrupt 
char curr_lcd[55];          // save current state of the lcd 

void main(void)
{
    initialize_pins();      // initialize pins (inputs and outputs)
    enter_samples();        // add samples to be tested  
    wait_asterisk();         // wait * to start the system
}

// Initialization Functions
void initialize_pins()
{
    lcd_init(16);
    DDRC = 0b00000111;              // keypad port (3 outputs , 4 inputs , 1 unused)
    PORTC = 0b11111000;             // enable pull up resistance for input pins

    DDRB = 0b0000011;               //motor pins (set them to be output)
    PORTB.0 = 1; PORTB.1 = 1;       // intialize the door to make it not moving


    DDRD.3 = 0;                     // set pc button pin (set the pin to be input)
    PORTD.3 = 1;                    //Pullup 
    DDRD.2 = 0;                     //admin push-pull button pin 
    PORTD.2 = 1;                    //Pullup   

    DDRD.5 = 1;                     // activate sounder bit  (set it to be output)

    SREG.7 = 1;                     // or #asm("sei")  => Enable global interrupt 
    GICR |= (1 << 6);               // Enable EXT_INT0
    MCUCR |= (1 << 1);              // Falling edge EXT_INT0  MCUCR.1=1
    MCUCR &= ~(1 << 0);             // MCUCR.0=0; 

    GICR |= (1 << 7);               //  Enable EXT_INT1
    MCUCR |= (1 << 3);              //  Falling edge EXT_INT1  MCUCR.3=1
    MCUCR &= ~(1 << 2);             //  MCUCR.2=0; 
}

void enter_samples()
{

    char names[][20] = { "Prof", "Ahmed", "Amr" ,"Adel" ,"Omar" , "MAX_ID" };
    unsigned int ids[] = { 111, 126, 128 , 130 , 132 , 999 };
    unsigned int passwords[] = { 203, 129, 325 , 426 ,79 , 999};

    unsigned int size = sizeof(names) / sizeof(names[0]);
    int i = 0;
    for (i = 0; i < size; i++)
    {
        curr_location = store(names[i], ids[i], passwords[i], curr_location);
    }

}

void wait_asterisk()
{
    if (!first_run)  // check it it's the first time to run the programe
    {
        delay_ms(1000);
        lcd_clear();
    }
    first_run = false;
    lcd_printf("Press *");  strcpy(curr_lcd, "Press *");          
    while (1)
    {
        c = keypad();

        if (c == '*')
        {
            mainPage();
        }
        else
        {
            error(1, "Please press *"); 
        }

    }
}

// User interaction and data operations 
void mainPage()
{
    unsigned int password = 0, id = 0;
    char* name = "";
    lcd_clear();
    lcd_printf("Enter your ID");                                                     
    lcd_gotoxy(0, 1); 
    strcpy(curr_lcd, "Enter your ID");  // save the current state of the lcd         
    
    id = read_lcd();

    if (exist(id))
    {
        lcd_clear();                   
        enter_password=true;   // enable the password mode 
        curr_num =-1;
        lcd_printf("Enter your PC:"); 
        strcpy(curr_lcd, "Enter your PC:");          
        lcd_gotoxy(0, 1);

        password = read_lcd(); 
        if (match_ID_PC(id, password))
        {
            name = get_name(id);
            lcd_clear();
            lcd_printf("Welcome, %s", name);
            open_door();
            close_door();
        }
        else
        {
            error(1, "Sorry, wrong PC");
        }
    }
    else
    {
        error(2, "Wrong ID");
    }  
    wait_asterisk();
}

// Function to read the input from lcd
unsigned int read_lcd()
{
    unsigned int num = 0, curr_digit = 0, three_digit = 0, col = 0;

    c = ' ';
    while (three_digit < 3)
    {                                            
        c = keypad();

        if (c == '*' || (c == '#' && three_digit == 0))
        {
            error(1, "");
        }
        else if (c == '#')  // use # to remove the last digit
        {
            lcd_gotoxy(--col, 1);
            lcd_printf("%c", '');
            three_digit--;      
            num/=10;              // remove the last digit
            if(!run_interrupt)   // check if we are in an interrupt        
                 curr_num = num; // save a copy of the number to use it after finishing the interrupt
        }
        else
        {
            three_digit++;
            lcd_gotoxy(col++, 1); 
            if(enter_password==true)  // we are in the password mode 
            {
                lcd_printf("*");            
            }          
            else
            {
                lcd_printf("%c", c);
            }

            curr_digit = c - '0';
            num *= 10;              
            num += curr_digit;       // add new digit to the number 
            if(!run_interrupt)
                 curr_num = num;
        }
    }     
    enter_password=false;    // disable password mode 
    delay_ms(700);
    lcd_clear();
    return num;
}

unsigned char keypad()
{
    while (1)
    {
        PORTC.0 = 0; PORTC.1 = 1; PORTC.2 = 1;
        //Only C1 is activated    (first column)
        switch (PINC)
        {
        case 0b11110110:       // first row is activated (be set with 0)  (col:1 , row 1)
            while (PINC.3 == 0);
            return '1';
            break;

        case 0b11101110:       // second row is activated (be set with 0)  (col:1 , row 2)
            while (PINC.4 == 0);
            return '4';
            break;

        case 0b11011110:       // third row is activated (be set with 0)   (col:1 , row 3)
            while (PINC.5 == 0);
            return '7';
            break;

        case 0b10111110:
            while (PINC.6 == 0);
            return '*';
            break;

        }


        PORTC.0 = 1; PORTC.1 = 0; PORTC.2 = 1;
        //Only C2 is activated       (second column)
        switch (PINC)
        {
        case 0b11110101:
            while (PINC.3 == 0);
            return '2';
            break;

        case 0b11101101:
            while (PINC.4 == 0);
            return '5';
            break;

        case 0b11011101:
            while (PINC.5 == 0);
            return '8';
            break;

        case 0b10111101:
            while (PINC.6 == 0);
            return '0';
            break;

        }


        PORTC.0 = 1; PORTC.1 = 1; PORTC.2 = 0;
        //Only C3 is activated       (third column)
        switch (PINC)
        {
        case 0b11110011:
            while (PINC.3 == 0);
            return '3';
            break;

        case 0b11101011:
            while (PINC.4 == 0);
            return '6';
            break;

        case 0b11011011:
            while (PINC.5 == 0);
            return '9';
            break;

        case 0b10111011:
            while (PINC.6 == 0);
            return '#';
            break;

        }

    }
}

// Function to check if it is the correct password for the given ID 
bool match_ID_PC(unsigned int id, unsigned int entered_passward)
{
    unsigned int id_passward = 0;
    id_passward = get_passward(id);
    return(id_passward == entered_passward);
}

// Function to handle INT1 (set PC)
void set_passcode()
{
    unsigned int old_password = 0, id = 0;

    lcd_clear();
    lcd_puts("Enter your ID");          
    lcd_gotoxy(0, 1);
    id = read_lcd();
    if (exist(id))
    {   enter_password=true; 
        lcd_puts("Enter old PC :"); 
        lcd_gotoxy(0, 1);
        old_password = read_lcd(); 
        if (match_ID_PC(id, old_password))
        {
            lcd_clear();
            enter_password=true; 
            lcd_puts("Enter new PC :");
            lcd_gotoxy(0, 1);
            update_password(id);
        }
        else
        {
            lcd_clear();
            error(2, "Contact Admin");
        }
    }
    else
    {
        lcd_clear();
        error(2, "Contact Admin");
    }


}

// Function to update the student's PC , we used it in set_passcode function
void update_password(unsigned int id)
{
    unsigned int new_passward = 0, reenter_new_password = 0, idx = 0;

    new_passward = read_lcd();
    lcd_clear(); 
    enter_password=true;  
    curr_num =-1;
    lcd_puts("Re-enter new PC");
    lcd_gotoxy(0, 1);
    reenter_new_password = read_lcd();
    if (new_passward != reenter_new_password) error(2, "Contact Admin");
    else
    {
        idx = get_id_location(id);
        idx += 2;   // skip id address lines       
                                                     
        // remove old passsward
        EE_Write(idx++, '0'); EE_Write(idx++, '0');

        //add the new passward
        idx -= 2;                              // return to the number of the first address that the passward can be stored in

        store_number(new_passward, idx, 1);  // store the new password

        lcd_clear();
        lcd_puts("New PC stored");
    }
}

// Function to retreive the password of the given ID
unsigned int get_passward(unsigned int id)
{
    unsigned int idx = 0, number = 0;
    idx = get_id_location(id);

    idx += 2;              // skip id address lines 

    // get the password
    number = get_number(idx);
    return number;

}

// Function to update student's PC by the admin 
void admin_update_password(unsigned int id, unsigned int new_passward)
{
    unsigned int idx = 0;
    idx = get_id_location(id);
    idx += 2;   // skip id address lines 

    // remove old passsward
    EE_Write(idx++, '0'); EE_Write(idx++, '0');

    //add the new passward
    idx -= 2;                               // return to the number of the first address that the passward can be stored in
    store_number(new_passward, idx, 1);   // store the new password

    lcd_clear();
    lcd_puts("PC is stored");
}

// Function to retreive the name of the given ID
char* get_name(unsigned int id)
{
    unsigned int idx = 0;
    char* name;

    idx = get_id_location(id);
    idx += 2; // skip the id address lines 
    idx += 2; // skip the password address lines

    // get the name
    name = get_name_fromEEPROM(idx);


    return name;

}

// Function to check if the person ID is stored
bool exist(unsigned int id)
{
    if (get_id_location(id) == -1) return 0;
    return 1;
}

// Function to get the location of the ID in EEPROM
int get_id_location(unsigned int id)
{
    unsigned int i = 0, number = 0, flag = 0, length;
    unsigned char ch;
    for (i = 0; i < curr_location; i++)       
    {
        ch = EE_Read(i);
        flag = check_flags(ch);
        if (flag == 0)  // ID  
        {
            number = get_number(i);
            if (number == id) return i;
            i++;    // skip the second byte

        }
        else if (flag == 1) // PC
        {
            i++; // skip PC bytes
        }
        else if (flag == 2)
        {
            length = get_nameLength(ch);
            i += length;   // skip the name
        }
    }
    return -1;
}

// Function to check if the current address is ID,PC or a name
unsigned int check_flags(unsigned char curr_char) {
    // Get the values of the last two bits (6,7)
    int bit6 = (curr_char >> 6) & 1;
    int bit7 = (curr_char >> 7) & 1;

    if (bit7 == 1 && bit6 == 0) {
        return 1;    // Check PC (10)
    }
    else if (bit7 == 0 && bit6 == 1) {
        return 0;   // Check ID (01)
    }
    else if (bit7 == 1 && bit6 == 1) {
        return 2;   // Check name (11)
    }

    // error 
    return 3;
}

// Function to get the length of the given name 
unsigned int get_nameLength(unsigned char ch)
{
    unsigned length = 0;
    length = ch;
    // disable flag
    length = SetBit0(length, 6);
    length = SetBit0(length, 7);
    return length;
}

// Function to handle INT0 (admin)
void admin_interaction()
{
    unsigned int AdminPc = 0, StudentID = 0, StudentPC = 0;

    lcd_clear();
    enter_password = true;
    lcd_printf("Enter Admin PC");
    lcd_gotoxy(0, 1);
    AdminPc = read_lcd();
    if (match_ID_PC(111, AdminPc))
    {
        lcd_clear();
        lcd_puts("Enter Student ID");
        lcd_gotoxy(0, 1);
        StudentID = read_lcd();
        if (exist(StudentID))
        {
            lcd_clear();
            enter_password = true;
            lcd_puts("Enter new PC");
            lcd_gotoxy(0, 1);
            StudentPC = read_lcd();
            admin_update_password(StudentID, StudentPC);
        }
        else
        {
            lcd_clear();
            error(1, "Contact Admin");
        }
    }
    else
    {
        lcd_clear();
        error(2, "Contact Admin");
    }

}


/*** EEPROM Storage and Retrieval Functions ***/

// Function to write an address from EEPROM
void EE_Write(unsigned int address, unsigned char data)
{
    while (EECR.1 == 1);    //Wait till EEPROM is ready
    EEAR = address;        //Prepare the address you want to read from
    EEDR = data;           //Prepare the data you want to write in the address above
    EECR.2 = 1;            //Master write enable
    EECR.1 = 1;            //Write Enable
}

// Function to read an address from EEPROM
unsigned char EE_Read(unsigned int address)
{
    while (EECR.1 == 1);    //Wait till EEPROM is ready
    EEAR = address;        //Prepare the address you want to read from

    EECR.0 = 1;            //Execute read command

    return EEDR;

}

// Function to store all person info in EEPROM
unsigned int store(char name[], unsigned int id, unsigned int password, unsigned int location)
{

    // Store Id 
    location = store_number(id, location, 0);

    // Store Password
    location = store_number(password, location, 1);

    // Store Name                       
    location = store_name(name, location);

    return location;
}

// Function to store the number (ID or PC) of the person in EEPROM
unsigned int store_number(unsigned int number, unsigned int location, bool ID_or_PC)
{
    unsigned char idByte1, idByte2;
    //get the last two bits of the number (8,9) .. and shift them to be bit (0,1) at the first byte
    idByte1 = ((number & 0b001100000000) >> 8);  

    if (ID_or_PC) idByte1 = 0b10000000 | idByte1;     // enable PC flag(10)
    else idByte1 = 0b01000000 | idByte1;             // enable id flag (01)
                                                                               
    
    // get the first 8 bits(0 > 7) from id to store them at byte2 
    idByte2 = number & 0b11111111;

    //store the number in EEPROM
    EE_Write(location++, idByte1);
    EE_Write(location++, idByte2);
     
    // we use two address lines of the EEPROM
    return location;
}

// Function to store the name of the person in EEPROM
unsigned int store_name(char name[], unsigned int location)
{
    unsigned int length = 0, i = 0;
    unsigned char name_byte;

    // get the length of the name
    length = 0;
    for (length = 0; name[length] != '\0'; length++) {}

    // prepare the byte that indicates the name info
    name_byte = length;                     // use the first 6 bits of tell use the length of the name

    name_byte = 0b11000000 | name_byte;      // enable name flag (11)

    //store the name_byte before the actual name in EEPROM
    EE_Write(location++, name_byte);

    // store the name in EEPROM
    i = 0;
    for (i = 0; i < length; i++) EE_Write(location++, name[i]);

    return location;
}

// Function to retrieve the number (ID or PC) of the person form EEPROM
unsigned get_number(unsigned int location)
{
    unsigned int number = 0, first_byte;

    // get the second byte value first
    number = EE_Read(location + 1);

    // disable the last two bits of the first byte  (flags)
    first_byte = EE_Read(location);
    first_byte = SetBit0(first_byte, 6);
    first_byte = SetBit0(first_byte, 7);


    //make the first two bits of the second byte equal to bits number (8,9) of number
    if (GetBit(first_byte, 0)) number = SetBit1(number, 8);
    if (GetBit(first_byte, 1)) number = SetBit1(number, 9);
    

    return number;
}

// Function to retrieve the name of the person form EEPROM
char* get_name_fromEEPROM(unsigned int location)
{
    unsigned int index = 0, length = 0;
    static char personName[17 + 1];

    // get the length of the name and disable the 6,7 bits (flags)
    length = EE_Read(location++);
    length = SetBit0(length, 6);
    length = SetBit0(length, 7);


    // get the name from EEPROM
    while (length--)
    {
        personName[index++] = EE_Read(location++);
    }


    return personName;
}

/*** Error functions ***/ 
void error(int number_of_peeps, const char* message) {
    while (number_of_peeps) {
        int i;
        for (i = 0; i < 25; i++) {
            PORTD.5 = 1;
            delay_ms(2);
            PORTD.5 = 0;
            delay_ms(2);
        }
        delay_ms(100);
        number_of_peeps--;
    }
    if (strlen(message) != 0)
    {
        lcd_clear();
        lcd_printf("%s", message);
    }

}

/*** Motor control functions ***/

// Function to open the door (motor control)
void open_door()
{
    PORTB.0 = 1;
    PORTB.1 = 0;
    delay_ms(1000);
    PORTB.1 = 1;
}

// Function to close the door (motor control)
void close_door()
{
    PORTB.0 = 0;
    PORTB.1 = 1;
    delay_ms(1000);
    PORTB.0 = 1;
}


/*** Bitwise manipulation ***/ 
unsigned int GetBit(unsigned int num, unsigned int idx) {
    return (num >> idx) & 1;
}

unsigned int SetBit1(unsigned int num, unsigned int idx) {
    return num | (1 << idx);
}

unsigned int SetBit0(unsigned num, unsigned int idx) {
    return num & ~(1 << idx);
}


// Function to handle what should be displayed after the interrupt
void handle_interrupt(bool check_password)
{
    delay_ms(1000);   
    lcd_clear();
    lcd_printf("%s", curr_lcd);
    if(curr_num != -1)   // this means that there was a number on the lcd before ther interrupt 
    {        
        lcd_gotoxy(0,1);
        if(check_password)  // means that the number was a PC
        {  
          while(curr_num != 0)
          {
            lcd_printf("*");
            curr_num/=10;
          }  
        } 
        else               // The mumber was an ID
        {
            lcd_printf("%d" , curr_num);
        }
        
    }                               
    curr_num=-1; 
    run_interrupt = false;                    // indicates that the interrupt has ended 
    if(check_password) enter_password=true;   // turn on the mode of writing PC (display('*') instead of numeric digits)
}


/*** Interrupt Service Routines ***/
interrupt[2] void admin_INT0(void)
{   bool check_password = false;   
    if(enter_password)check_password=true,enter_password=false; // indicates that the user was writing a PC before the interrupt
    run_interrupt=true;        // indicates the starting of the interrupt
    admin_interaction();  
    handle_interrupt(check_password);
   
}

interrupt[3] void setPC_INT1(void)
{   bool check_password = false;
    if(enter_password)check_password=true,enter_password=false; 
    run_interrupt=true;
    set_passcode();              
    handle_interrupt(check_password);
}
