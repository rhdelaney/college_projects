/*** red-black binary search tree class ***/ // now being my vbst.h
#include <stdio.h>
#include <stdlib.h>
#include "bst.h"
#ifndef __VBST_INCLUDED__
#define __VBST_INCLUDED__


//someone else used this idk how useful it may be

typedef struct vbst{
    bst *tree;
    void (*display)(FILE *,void *);
    int (*compare)(void *,void *);
    int size;
    int words;
} vbst;

extern vbst *newVBST(void (*)(FILE *,void *),int (*)(void *,void *));
extern void insertVBST(vbst *,void *);
extern int findVBST(vbst *,void *);
extern void deleteVBST(vbst *,void *);
extern int sizeVBST(vbst *);
extern int wordsVBST(vbst *);
extern void statisticsVBST(vbst *,FILE *);
extern void displayVBST(FILE *,vbst *);
//extern void checkVBST(vbst *);               //optional
#endif