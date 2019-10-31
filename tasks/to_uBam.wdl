task unMap {
    input{
        File mapped_bam
        String unmapped_base
        String gatk_docker = "us.gcr.io/broad-gatk/gatk:4.0.10.1"
    }


    command {
        gatk RevertSam --java-options "-Xmx7600m" \
            -I=${mapped_bam} \
            -O=${unmapped_base}.unmapped.bam \
            --SANITIZE=true \
            --MAX_DISCARD_FRACTION=0.005 \
            --ATTRIBUTE_TO_CLEAR=XT \
            --ATTRIBUTE_TO_CLEAR=XN \
            --ATTRIBUTE_TO_CLEAR=AS \
            --ATTRIBUTE_TO_CLEAR=OC \
            --ATTRIBUTE_TO_CLEAR=OP
    }

  runtime {
    docker: gatk_docker
    preemptible: preemptible_tries
    memory: "8 GiB"
    cpu: "2"
    disks: "local-disk " + disk_size + " HDD"
  }

  output {
        File out = "${unmapped_base}.unmapped.bam"
  }

}
