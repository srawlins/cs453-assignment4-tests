extern void print_int(int to_print);
extern void print_string(char to_print[]);

int i;
int x;
int integer_array[12];
char char_array[64];
char single_char;

void print_int_wrapper(int input)
{
print_int(input);
}

void print_string_wrapper(char input[])
{
print_string(input);
}

void change_global_x(void)
{
x = 55;
}

void change_global_i(int new_value)
{
i = new_value;
}

void changes_parameter(int parameter)
{
print_int(parameter);
print_string("\n");

parameter = 50;
print_int(parameter);
}

void main(void)
{
print_int_wrapper(99);
print_string_wrapper("testing\n");

print_int(45);
print_string("\n");
x = 3;
print_int(x);
print_string("\n");

i = x;
print_int(i);
print_string("testing!\n");

print_int_wrapper(i);
print_string_wrapper("\n");
print_int_wrapper(x);

print_string("\n\n");

change_global_x();
print_int(x);

print_string("\n");

change_global_i(1234);
print_int(i);

print_string("\n");

single_char = 'd';
print_int(single_char);

print_string("\n");

/*single_char = -100;
print_int(single_char);*/ /* I think the specification might be incorrect about how to handle negative numbers, so I've commented this out. */

changes_parameter(73);

/*i = 3 + 4 - 5;
i = 3 - 5;
i = 3 + 5;*/
}
