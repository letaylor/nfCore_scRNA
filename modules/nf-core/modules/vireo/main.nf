
process VIREO {
    tag "${samplename}"
    label 'process_high'
    publishDir "${params.outdir}/vireo/${samplename}/", mode: "${params.vireo.copy_mode}", overwrite: true,
	  saveAs: {filename -> filename.replaceFirst("vireo_${samplename}/","") }
    
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "/software/hgi/containers/scrna_deconvolution_latest.img"
    } else {
        container "quay.io/biocontainers/multiqc:1.10.1--py_0"
    }

     when: 
      params.run_with_genotype_input

    input:
      tuple val(samplename), path(cell_data), val(n_pooled), path(donors_gt_vcf)
      

    output:
      tuple val(samplename), path("vireo_${samplename}/*"), emit: output_dir
      tuple val(samplename), path("vireo_${samplename}/donor_ids.tsv"), emit: sample_donor_ids 
      path("vireo_${samplename}/${samplename}.sample_summary.txt"), emit: sample_summary_tsv
      path("vireo_${samplename}/${samplename}__exp.sample_summary.txt"), emit: sample__exp_summary_tsv

    script:
    """

      umask 2 # make files group_writable

      vireo -c $cell_data -N $n_pooled -o vireo_${samplename} -d ${donors_gt_vcf} -t GT


      # add samplename to summary.tsv,
      # to then have Nextflow concat summary.tsv of all samples into a single file:

      cat vireo_${samplename}/summary.tsv | \\
        tail -n +2 | \\
        sed s\"/^/${samplename}\\t/\"g > vireo_${samplename}/${samplename}.sample_summary.txt

      cat vireo_${samplename}/summary.tsv | \\
        tail -n +2 | \\
        sed s\"/^/${samplename}__/\"g > vireo_${samplename}/${samplename}__exp.sample_summary.txt

    """
}
