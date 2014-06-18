#/bin/bash
# chown sur chacun des dossiers synchronises
liste=$(echo "${!sync_src[@]}" | sed 's/ /\n/g' | sort -n)
for k in $liste
do
    sync_src_current_value=${sync_src[$k]}
    sync_dst_current_value=${sync_dst[$k]}
    chown -R user:group $sync_dst_current_value
done
