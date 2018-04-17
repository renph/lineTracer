#include <stdio.h>
#include <string.h>
#include "mex.h"


#define writeDebugStream mexPrintf
#define writeDebugStreamLine mexPrintf
void matrixMultF(float* matrixA, float* matrixB, short numRowsA, short numColsA, short numColsB, float* matrixC)
{
    short i, j, k;
    for (i = 0; i < numRowsA; i++)
        for(j = 0; j < numColsB; j++)
        {
            matrixC[numColsB * i + j] = 0;
            for (k = 0; k < numColsA; k++)
                matrixC[numColsB*i+j]= matrixC[numColsB*i+j]+matrixA[numColsA*i+k]*matrixB[numColsB*k+j];
        }
}

void matrixAddF(float* matrixA, float* matrixB, short numRowsA, short numColsA, float* matrixC)
{
    short i, j;
    for (i = 0; i < numRowsA; i++)
        for(j = 0; j < numColsA; j++)
            matrixC[numColsA * i + j] = matrixA[numColsA * i + j] + matrixB[numColsA * i + j];
}

void matrixPrintF(float* matrix, short numRows, short numCols, char* label){
    // matrixA = input matrix (numRowsA x n)
    short i,j;
    writeDebugStreamLine(label);
    for (i=0; i<numRows; i++){
        for (j=0;j<numCols;j++){
            writeDebugStream("%f", matrix[numCols*i+j]);
            writeDebugStream(", ");
        }
        writeDebugStreamLine("\n");
    }
}

void matrixCopyF(float* source, short numRows, short numCols, float* destination)
{
    memcpy(destination, source, numRows * numCols * sizeof(float));
}

#define power 30
#define th 50.0

#define eta 0.0001
#define nin 2
#define nhide 5
#define nout 1

float xmin = -39;
float igain = 0.034483;
//float ogain = 0.011401;
//float omin = -60;//
float ymin = -0.55;

//float IW[nhide][nin] =
//{0.372681, 1.014068,
//-0.164034, -0.036253,
//-0.317155, -0.466234,
//0.537137, 0.371737,
//0.443629, -0.529682};
//float b1[nhide][nout] = {0.409595, 0.639809, -0.127036, 0.005008, 0.035201};

//float LW[nout][nhide] = {0.529815, 0.765309, -0.380507, -0.382019, -0.090987};
//float b2 = -0.767044;

float IW[nhide][nin] =
        {1.694370,	-5.044305	,
         -0.048763,	-1.577429	,
         -0.912368,	2.589271	,
         0.966140,	-0.702421	,
         -0.203890,	2.106619};
float b1[nhide] =
        {1.044529,	0.704230,	-0.393451,	-0.005903,	-0.572817	};
float LW[nout][nhide] =
        {0.231872,	-1.103564,	0.018529,	1.140000,	0.050274	};
float b2[nout]=
        {-0.567912	};

#define upper 2
#define lower -2
#define POPSIZE 10               /* population size */
#define MAXGENS 15             /* max. number of generations */
#define NVARS 21                  /* no. of problem variables */
#define PXOVER 0.5               /* probability of crossover */
#define PMUTATION 0.05           /* probability of mutation */
#define LAMB 0.15

#define IWi  0
#define b1i  (nhide * nin)
#define LWi  (nhide * nin + nhide * nout)
#define b2i  (nhide * nin + nhide * nout + nout * nhide)


int generation;                  /* current generation no. */
//int cur_best;                    /* best individual */

struct genotype /* genotype (GT), a member of the population */
{
    float gene[NVARS];        /* a string of variables */
    float fitness;            /* GT's fitness */
    float rfitness;           /* relative fitness */
    float cfitness;           /* cumulative fitness */
};
struct genotype population[POPSIZE+1];    /* population */
struct genotype newpopulation[POPSIZE+1]; /* new population; */


void initialize(void);//
float randval(float low, float high);
//void evaluate(void);//
//void keep_the_best(void);
void elitist(void);
void select(void);
void crossover(void);
void Xover(int one,int two);
void swap(float *x, float *y);
void mutate(void);
//void report(void);//


void initialize(void)
{
// 	srand(nSysTime);
    generation=0;
    int i, j;
    float *p = population[0].gene;
    /* initialize variables within the bounds */

    population[POPSIZE].rfitness = 0;
    population[POPSIZE].cfitness = 0;
    population[POPSIZE].fitness = 0;
    matrixCopyF(IW, nhide, nin, p+IWi);
    matrixCopyF(b1, nhide, nout, p+b1i);
    matrixCopyF(LW, nout, nhide, p+LWi);
    matrixCopyF(b2, nout, 1, p+b2i);


    for (j = 1; j < POPSIZE; j++)
    {
        population[j].fitness = 0;
        for (i = 0; i < NVARS; i++)
        {
            population[j].rfitness = 0;
            population[j].cfitness = 0;
            population[j].gene[i] = p[i] + randval(-2.0, 2.0);
        }
    }
}
/***********************************************************/
/* Random value generator: Generates a value within bounds */
/***********************************************************/
float randval(float low, float high)
{
    float val;
    val = ((float)(rand()%1000)/1000.0)*(high - low) + low;
    return(val);
}

/***************************************************************/
/* Keep_the_best function: This function keeps track of the    */
/* best member of the population. Note that the last entry in  */
/* the array Population holds a copy of the best individual    */
/***************************************************************/
void copyGene(int srcMem, int dstMem)
{
    short i;
    for (i = 0; i < NVARS; i++)
        population[dstMem].gene[i] = population[srcMem].gene[i];
    population[dstMem].fitness = population[srcMem].fitness;
}
//void keep_the_best()
//{
//	int mem;
//	int i;
//	cur_best = 0; /* stores the index of the best individual */
//	float best = population[0].fitness;
//	for (mem = 1; mem < POPSIZE; mem++)
//	{
//		if (population[mem].fitness > best)
//		{
//			cur_best = mem;
//			best = population[mem].fitness;
//		}
//	}
//	/* once the best member in the population is found, copy the genes */
//	copyGene(cur_best, POPSIZE);
//}
/****************************************************************/
/* Elitist function: The best member of the previous generation */
/* is stored as the last in the array. If the best member of    */
/* the current generation is worse then the best member of the  */
/* previous generation, the latter one would replace the worst  */
/* member of the current population                             */
/****************************************************************/
void elitist()//////
{
    int i;//,j
    float best, worst;             /* best and worst fitness values */
    int best_mem=0, worst_mem=0; /* indexes of the best and worst member */
    best = population[0].fitness;
    worst = population[0].fitness;
    for (i = 1; i < POPSIZE ; ++i)
    {
        if (population[i].fitness > best)
        {
            best = population[i].fitness;
            best_mem = i;
        }
        else if (population[i].fitness < worst)
        {
            worst = population[i].fitness;
            worst_mem = i;
        }
    }

    /* if best individual from the new population is better than */
    /* the best individual from the previous population, then    */
    /* copy the best from the new population; else replace the   */
    /* worst individual from the current population with the     */
    /* best one from the previous generation                     */
    if (best > population[POPSIZE].fitness)
    {
        copyGene(best_mem, POPSIZE);
        writeDebugStreamLine("gen%dbest men=%d fitness=%f\n",generation,best_mem, best);
        float *p =population[POPSIZE].gene;
        matrixPrintF(p+IWi,nhide,nin,"float IW[nhide][nin] =");
        matrixPrintF(p+b1i,1,nhide,"float b1[nhide] =");
        matrixPrintF(p+LWi,nout,nhide,"float LW[nout][nhide] =");
        matrixPrintF(p+b2i,1,1,"float b2[nout]=");
    }
    else
    {
        copyGene(POPSIZE, worst_mem);
//		Xover(worst_mem, best_mem);
    }
}
/**************************************************************/
/* Selection function: Standard proportional selection for    */
/* maximization problems incorporating elitist model - makes  */
/* sure that the best member survives                         */
/**************************************************************/
void select(void)
{
    int mem, i, j;//, k;
    float sum = 0;
    float p;
    /* find total fitness of the population */
    for (mem = 0; mem < POPSIZE; mem++)
    {
        sum += population[mem].fitness;
    }
    writeDebugStreamLine("gen%d\taverage fitness=%f\n",generation, sum/POPSIZE);
    /* calculate relative fitness */
    for (mem = 0; mem < POPSIZE; mem++)
    {
        population[mem].rfitness =  population[mem].fitness/sum;
    }
    /* calculate cumulative fitness */
    population[0].cfitness = population[0].rfitness;
    for (mem = 1; mem < POPSIZE; mem++)
    {
        population[mem].cfitness =  population[mem-1].cfitness +
                                    population[mem].rfitness;
    }
    /* finally select survivors using cumulative fitness. */
    for (i = 0; i < POPSIZE; i++)
    {
        p = rand()%1000/1000.0;
        if (p < population[0].cfitness)
            newpopulation[i] = population[0];
        else
        {
            for (j = 0; j < POPSIZE; j++)
                if (p >= population[j].cfitness &&
                    p<population[j+1].cfitness)
                    newpopulation[i] = population[j+1];
        }
    }
    /* once a new population is created, copy it back */
    for (i = 0; i < POPSIZE; i++)
        population[i] = newpopulation[i];
}
/***************************************************************/
/* Crossover selection: selects two parents that take part in  */
/* the crossover. Implements a single point crossover          */
/***************************************************************/
void crossover(void)
{
    int  mem, one;
    int first  =  0; /* count of the number of members chosen */
    float x;
    for (mem = 0; mem < POPSIZE; ++mem)
    {
        x = rand()%1000/1000.0;
        if (x < PXOVER)
        {
            ++first;
            if (first % 2 == 0)
                Xover(one, mem);
            else
                one = mem;
        }
    }
}
/**************************************************************/
/* Crossover: performs crossover of the two selected parents. */
/**************************************************************/
void Xover(int one, int two)
{
    int i;
    int point; /* crossover point */
    /* select crossover point */
    if(NVARS > 1)
    {
        if(NVARS == 2)
            point = 1;
        else
            point = (rand() % (NVARS - 1)) + 1;
        for (i = 0; i < point; i++)
            swap(&population[one].gene[i], &population[two].gene[i]);
    }
}
/*************************************************************/
/* Swap: A swap procedure that helps in swapping 2 variables */
/*************************************************************/
void swap(float *x, float *y)
{
    float temp;
    temp = LAMB*(*y)+(1-LAMB)*(*x);
    *x = LAMB*(*x)+(1-LAMB)*(*y);
    *y = temp;
}
/**************************************************************/
/* Mutation: Random uniform mutation. A variable selected for */
/* mutation is replaced by a random value between lower and   */
/* upper bounds of this variable                              */
/**************************************************************/
void mutate(void)
{
    int i, j;
    float x;
    for (i = 0; i < POPSIZE; i++)
        for (j = 0; j < NVARS; j++)
        {
            x = rand()%1000/1000.0;
            if (x < PMUTATION)
            {
                /* find the bounds on the variable to be mutated */
                population[i].gene[j] = randval(lower, upper);
            }
        }
}
/***************************************************************/
/* Report function: Reports progress of the simulation. Data   */
/* dumped into the  output file are separated by commas        */
/***************************************************************/
//void report(void)//
//{
//    int i;
//    float best_val;            /* best population fitness */
//    float avg;                 /* avg population fitness */
//    float stddev;              /* std. deviation of population fitness */
//    float sum_square;          /* sum of square for std. calc */
//    float square_sum;          /* square of sum for std. calc */
//    float sum;                 /* total population fitness */
//    sum = 0.0;
//    sum_square = 0.0;
//    for (i = 0; i < POPSIZE; i++)
//    {
//        sum += population[i].fitness;
//        sum_square += population[i].fitness * population[i].fitness;
//    }
//    avg = sum/(float)POPSIZE;
//    square_sum = avg * avg * POPSIZE;
//    stddev = sqrt((sum_square - square_sum)/(POPSIZE - 1));
//    best_val = population[POPSIZE].fitness;
//    mexPrinf("%5d,      %6.6f, %6.3f, %6.3f \n", generation,
//             best_val, avg, stddev);
//}

//float inputs[2][1]={17,17};
float outputs = 0;

float pre[nin]={0.0,0.0};
float post;
float temp1[nhide];

void
mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
    mexPrintf("start\n");
    if (nrhs>0)
        gann1();
    else
        gann();

}

int gann1()
{
    float E=0;
    float sE=0;

    short mem=0;
    initialize();
    short trial = 0;
    float fit = 0;
    float *p = (population[mem].gene);

    int cnt=0;
    int steps=200;
    int i;
    mxArray *lhs[1],*rhs[4];
    rhs[0] = mxCreateDoubleMatrix(1, 1, mxDOUBLE_CLASS);
    rhs[1] = mxCreateDoubleMatrix(1, 1, mxDOUBLE_CLASS);
    rhs[2] = mxCreateDoubleMatrix(1, 1, mxDOUBLE_CLASS);
    rhs[3] = mxCreateDoubleMatrix(1, 1, mxDOUBLE_CLASS);
    *mxGetPr(rhs[2]) = 0.1; //dt
    *mxGetPr(rhs[3]) = 20; //nRec

    mexCallMATLAB(0, NULL, 1, &rhs[3], "animCar");
    float vL,vR;
    mem = 0;
    for(mem =0;;)
    {
        sE = 0.0;
        p = (population[POPSIZE].gene);
        mexCallMATLAB(0,NULL,0, NULL, "resetEnv");
        for(i=0;i<steps;i++)
        {
            mexCallMATLAB(1,&lhs[0],0, NULL, "getLight");
            E = *mxGetPr(lhs[0]) - th;
            pre[0] = E / 20.0;
            matrixMultF(p+IWi,pre,5,2,1,temp1);
            //matrixPrintF(temp1,5,1,"mul");
            matrixAddF(temp1,p+b1i,5,1,temp1);
            //matrixPrintF(temp1,5,1,"mul+b");
            //satlins(temp1,5,1,temp1);
            matrixMultF(p+LWi,temp1,1,5,1,&post);
            outputs = post+*(p+b2i);//post+b2-ymin)/ogain + omin;
            *mxGetPr(rhs[0]) = 12 + outputs;
            *mxGetPr(rhs[1]) = 12 - outputs;
            mexCallMATLAB(0, NULL, 3, &rhs, "updatePos");
            mexCallMATLAB(0, NULL, 0, NULL, "animCar");
            pre[1]=pre[0];
            sE += E*E;
        }
        population[mem].fitness = 50000.0 - sE;
//            mexPrintf("gen%d-%d err=%f\n",generation,mem, sE);

    }




}

int gann()
{
    //preprocess(inputs, 2, pre);
    //matrixPrintF(pre,2,1,"pre");
    float E=0;
    //float E1=30;
    //float uk=0;

    //float vc=0;
    float sE=0;//err=0,totalErr=0,

    short mem;
    initialize();
    short trial = 0;
    float fit = 0;
    float *p = (population[mem].gene);

    int cnt=0;
    int steps=120;
    int i;
    mxArray *lhs[1],*rhs[4];
    rhs[0] = mxCreateDoubleMatrix(1, 1, mxDOUBLE_CLASS);
    rhs[1] = mxCreateDoubleMatrix(1, 1, mxDOUBLE_CLASS);
    rhs[2] = mxCreateDoubleMatrix(1, 1, mxDOUBLE_CLASS);
    rhs[3] = mxCreateDoubleMatrix(1, 1, mxDOUBLE_CLASS);
    *mxGetPr(rhs[2]) = 0.1; //dt
    *mxGetPr(rhs[3]) = 20; //dt

    mexCallMATLAB(0, NULL, 1, &rhs[3], "animCar");
    float vL,vR;
    while(generation<MAXGENS)
    {

        cnt++;
        for(mem =0;mem < POPSIZE;mem++)
        {
            sE = 0.0;
            p = (population[mem].gene);
            mexCallMATLAB(0,NULL,0, NULL, "resetEnv");
            for(i=0;i<steps;i++)
            {
                mexCallMATLAB(1,&lhs[0],0, NULL, "getLight");
                E = *mxGetPr(lhs[0]) - th;
                pre[0] = E / 20.0;
                matrixMultF(p+IWi,pre,5,2,1,temp1);
                //matrixPrintF(temp1,5,1,"mul");
                matrixAddF(temp1,p+b1i,5,1,temp1);
                //matrixPrintF(temp1,5,1,"mul+b");
                //satlins(temp1,5,1,temp1);
                matrixMultF(p+LWi,temp1,1,5,1,&post);
                outputs = post+*(p+b2i);//post+b2-ymin)/ogain + omin;
                *mxGetPr(rhs[0]) = 12 + outputs;
                *mxGetPr(rhs[1]) = 12 - outputs;
                mexCallMATLAB(0, NULL, 3, &rhs, "updatePos");
                mexCallMATLAB(0, NULL, 0, NULL, "animCar");
                pre[1]=pre[0];
                sE += E*E;
            }
            population[mem].fitness = 50000.0 - sE;
//            mexPrintf("gen%d-%d err=%f\n",generation,mem, sE);

        }

        if(mem >= POPSIZE)
        {
            //update
            generation++;

            elitist();
            select();
            crossover();
            mutate();
        }

    }

}
