#include<linux/module.h>
#include<linux/kernel.h>

MODULE_LICENSE("GPL"); // Specify the license
MODULE_AUTHOR("Your Name");
MODULE_DESCRIPTION("A simple example of a Linux kernel module");

int init_module() {
	printk(KERN_INFO "CATS MODULE LOADED !\n"); //print kernel 
	return 0;
}

// delte the module 
void cleanup_module(){
	printk(KERN_INFO "CATS MODULE UNLOADED ..... !\n");
}
