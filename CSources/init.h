//
//  init.h
//  Term-Project-534
//
//  Created by Yifan Huang on 10/5/22.
//

#include <stdint.h>

void init();
void user_given_array(int64_t array_ptr_addr);
void print_array_addr(int64_t array_ptr_addr);
void user_set_array();
void user_given_slice(int64_t slice_ptr_addr);
int64_t get_cb_from_c();
void do_nothing();
