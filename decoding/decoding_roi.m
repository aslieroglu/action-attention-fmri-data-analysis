analysis_types={'womanvsman','handvsfeet','humanvsobject'};
task_types={'attendtoactor','attendtoeffector','attendtotarget'};
masks={'psts_left','psts_right','parietal_left','parietal_right','premotor_left','premotor_right'};


actor_order={'female','female','female','female','male','male','male','male'};
actor_order_decoding=repelem(actor_order,2);
actor_label=[1 1 1 1 1 1 1 1 -1 -1 -1 -1 -1 -1 -1 -1];

effector_order={'foot','foot','hand','hand','foot','foot','hand','hand'};
effector_order_decoding=repelem(effector_order,2);
effector_label=[1 1 1 1 -1 -1 -1 -1 1 1 1 1 -1 -1 -1 -1];

target_order={'human','object','human','object','human','object','human','object'};
target_order_decoding=repelem(target_order,2);
target_label=[1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1];

tot_sub=27;

act_vid_nos=[1:16 59:74 117:132 175:190 233:248 291:306 349:364 407:422]; %128 trial 8runs -> 16 beta from each
eff_vid_nos=act_vid_nos+16;
tar_vid_nos=eff_vid_nos+16;

%active_vid_nos=[act_vid_nos; eff_vid_nos; tar_vid_nos];
for mask=1:6
    for sub_no=1:tot_sub
        for task=1:3
            for analysis=1:3
                % Clear cfg (otherwise if you re-run this script, previous parameters may still be present)
                clear cfg
        
                tot_run=8;
        
                if sub_no==7 || sub_no== 17
                    tot_run=6;
                elseif sub_no==2 || sub_no==12 || sub_no==22
                    tot_run=7;
                end
                 
                % To set the path and add subdirectories to the path, run
                cfg = decoding_defaults;
                cfg.analysis = 'roi';
                % Specify where the results should be saved, e.g. 'c:\exp\results\buttonpress'
                output_path=['D:\Decoding_ROI\sub',num2str(sub_no),'\', masks{mask},'\', task_types{task},'\', analysis_types{analysis}];
                cfg.results.dir=output_path;
                %beta_loc=strcat('E:\spm_ActionAttention\subjects\sub', num2str(sub_no), '\1stlevel_block_active');
                %regressor_names = design_from_spm(beta_loc);
                names={};
        
                cd(['E:\spm_ActionAttention\subjects\sub' num2str(sub_no) '\1stlevel_decoding_active'])
        
                switch task
                    case 1
                        beta_nos=act_vid_nos(1:tot_run*16);
                    case 2
                        beta_nos=eff_vid_nos(1:tot_run*16);
                    case 3
                        beta_nos=tar_vid_nos(1:tot_run*16);
                end
    
                for beta=1:size(beta_nos,2) 
                        file_name=[pwd '\beta_' sprintf('%04d', beta_nos(1,beta)) '.nii'];
                        names{end+1}=file_name;
                end
        
                switch analysis
                    case 1
                    %% female vs male
        
                     chunk=[repelem(1:tot_run,16)];
                     labelArr=repmat(actor_label,1,tot_run);
                     labelnames=[repmat(actor_order_decoding,1,tot_run)];
        
                    case 2
                    %% hand vs feet
        
                    chunk=[repelem(1:tot_run,16)];
                    labelArr=repmat(effector_label,1,tot_run);
                    labelnames=[repmat(effector_order_decoding,1,tot_run)];
        
                    case 3
                    %% human vs object
        
                     chunk=[repelem(1:tot_run,16)];
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
                cfg.files.mask = ['E:\spm_ActionAttention\subjects\ROIs\', masks{mask},'.nii'];
                       
                %cfg = decoding_describe_data(cfg,labelnames,labels,regressor_names,beta_loc);
                %"act_v1","act_v2","act_v3","act_v4","act_v5","act_v6","act_v7","act_v8", "eff_v1","eff_v2","eff_v3","eff_v4","eff_v5","eff_v6","eff_v7","eff_v8"
                
                cfg.design = make_design_cv(cfg);
                
                cfg.verbose = 1;
                
                cfg.decoding.method = 'classification_kernel'; % default 
                
                cfg.results.output = {'accuracy_minus_chance','confusion_matrix', 'AUC_minus_chance'};
                cfg.plot_selected_voxels=0;
                cfg.plot_design = 0; % this will call display_design(cfg);
                results = decoding(cfg);
        
            end
        end
    end
end
