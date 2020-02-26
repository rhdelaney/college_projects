#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "scanner.h"

typedef struct node {
	char *name;
	struct node *next;
} Node;

Node *addList(Node *theList, char *theName) {
	Node *newNode = (Node *) malloc ( sizeof(Node) );
	newNode->name = theName;
	newNode->next = theList;
	return newNode;
}

void printList(Node *node) {
	Node *ptr = node;
	printf("The list is : \n");
	while (ptr != NULL) {
		printf("\t%s\n", ptr->name);
		ptr = ptr->next;
	}
	return;
}

char *last(Node *head){
	if(head->next==NULL){
		return head->name;}
	else{
		head=head->next;
		return last(head);}
//	while(head!=NULL){
//		last=head->name;
//		head=head->next;
//}
//	return last;
}

int main( ) {
	Node *head = NULL;
	char *name;
	printf("Enter a name to add to the list (or 'quit' to exit) : ");
	name = readToken(stdin);
	while (strcmp(name, "quit") != 0) {
		head = addList(head, name);
		printf("Enter a name to add to the list (or 'quit' to exit) : ");
		name = readToken(stdin);
	}
	printList(head);

	// Uncomment the four lines below for problem #4
	if ( last(head) )
		printf("\nThe last name in the list is %s\n", last(head) );
	else
		printf("No items in the list\n");
	
	return 0;
}