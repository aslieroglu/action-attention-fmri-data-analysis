analysis_types={'womanvsman','handvsfeet','humanvsobject'};
%masks={'psts_left','psts_right','parietal_left','parietal_right','premotor_left','premotor_right'};
masks={'lotc_left'};

actor_order={'female','female','female','female','male','male','male','male'};
actor_order_decoding=repelem(actor_order,4);
actor_label=[1 1 1 1 -1 -1 -1 -1];
actor_label=repelem(actor_label,4);

effector_order={'foot','foot','hand','hand','foot','foot','hand','hand'};
effector_order_decoding=repelem(effector_order,4);
effector_label=[1 1 -1 -1 1 1 -1 -1];
effector_label=repelem(effector_label,4);

target_order={'human','object','human','object','human','object','human','object'};
target_order_decoding=repelem(target_order,4);
target_label=[1 -1 1 -1 1 -1 1 -1];
target_label=repelem(target_label,4);

tot_sub=27;

beta_nos_per_run=[1:4, 7:10, 13:16, 19:22, 25:28, 31:34, 37:40, 43:46]; 
%taking 4 trials from each trial so that the beta numbers could be equal
%the ones we used in active sessions
                                                                        

%active_vid_nos=[act_vid_nos; eff_vid_nos; tar_vid_nos];
for mask=1 %1:6
    for sub_no=1:tot_sub
        for analysis=1:3
            % Clear cfg (otherwise if you re-run this script, previous parameters may still be present)
            clear cfg
    
            tot_run=4;
    
            if sub_no==2 
                tot_run=3;
            end
                
            beta_nos=beta_nos_per_run;
            for i=1:tot_run-1
                beta_nos=[beta_nos beta_nos_per_run+(i*57)];
            end
             
            % To set the path and add subdirectories to the path, run
            cfg = decoding_defaults; % use cfg = decoding_defaults to set the defaults, too
            cfg.analysis = 'roi';
            % Specify where the results should be saved, e.g. 'c:\exp\results\buttonpress'
            output_path=['D:\Decoding_ROI_passive\sub',num2str(sub_no),'\', masks{mask},'\', analysis_types{analysis}];
            cfg.results.dir=output_path;
    %       beta_loc=strcat('E:\spm_ActionAttention\subjects\sub', num2str(sub_no), '\1stlevel_block_active');
    %       regressor_names = design_from_spm(beta_loc);
            names={};
    
            cd(['E:\spm_ActionAttention\subjects\sub' num2str(sub_no) '\1stlevel_decoding_passive'])
        
            for beta=1:size(beta_nos,2) 
                    file_name=[pwd '\beta_' sprintf('%04d', beta_nos(1,beta)) '.nii'];
                    names{end+1}=file_name;
            end
    
            switch analysis
                case 1
                %% female vs male
    
                 chunk=[repelem(1:tot_run,32)];
                 labelArr=repmat(actor_label,1,tot_run);
                 labelnames=[repmat(actor_order_decoding,1,tot_run)];
    
                case 2
                %% hand vs feet
    
                chunk=[repelem(1:tot_run,32)];
                labelArr=repmat(effector_label,1,tot_run);
                labelnames=[repmat(effector_order_decoding,1,tot_run)];
    
                case 3
                %% human vs object
    
                 chunk=[repelem(1:tot_run,32)];
                 labelArr=repmat(target_label,1,tot_run);
                 labelnames=[repmat(target_order_decoding,1,tot_run)];
    
            end
    
    
             cfg.files.name=names';
             cfg.files.chunk=chunk';         
             cfg.files.label=labelArr';
             cfg.files.labelname=labelnames';
            
            % Set the filename of your brain mask (or your ROI masks as cell matrix) 
            % for searchlight or wholebrain e.g. 'c:\exp\glm\model_button\mask.img' OR 
            % for ROI e.g. {'c:\exp\roi\roimaskleft.img', 'c:\exp\roi\roimaskright.img'}
            % You can also use a mask file with multiple masks inside that are
            % separated by different integer values (a "multi-mask")

            mask_path=['E:\spm_ActionAttention\subjects\ROIs\' masks{mask} '.nii'];
            cfg.files.mask = mask_path;
                   
            %cfg = decoding_describe_data(cfg,labelnames,labels,regressor_names,beta_loc);
            %"act_v1","act_v2","act_v3","act_v4","act_v5","act_v6","act_v7","act_v8", "eff_v1","eff_v2","eff_v3","eff_v4","eff_v5","eff_v6","eff_v7","eff_v8"
            
            cfg.design = make_design_cv(cfg);
            
            cfg.verbose = 1;
            
            cfg.decoding.method = 'classification_kernel'; % this is our default anyway.
            
            cfg.results.output = {'accuracy_minus_chance','confusion_matrix', 'AUC_minus_chance'};
            cfg.plot_selected_voxels=0;
            cfg.plot_design = 0; % this will call display_design(cfg);
            results = decoding(cfg);
    
        end
    end
end
