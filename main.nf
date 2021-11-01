#!/usr/bin/env nextflow
/*
========================================================================================
    nf-core/scdecon
========================================================================================
    Github : https://github.com/nf-core/scdecon
    Website: https://nf-co.re/scdecon
    Slack  : https://nfcore.slack.com/channels/scdecon
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2

/*
========================================================================================
    VALIDATE & PRINT PARAMETER SUMMARY
========================================================================================
*/


/*
========================================================================================
    NAMED WORKFLOW FOR PIPELINE
========================================================================================
*/

include { SCDECON } from './workflows/scdecon'

//
// WORKFLOW: Run main nf-core/scdecon analysis pipeline
//
workflow NFCORE_SCDECON {
    SCDECON ()
}

/*
========================================================================================
    RUN ALL WORKFLOWS
========================================================================================
*/

//
// WORKFLOW: Execute a single named workflow for the pipeline
// See: https://github.com/nf-core/rnaseq/issues/619
//
workflow {
    NFCORE_SCDECON ()
}

/*
========================================================================================
    THE END
========================================================================================
*/
