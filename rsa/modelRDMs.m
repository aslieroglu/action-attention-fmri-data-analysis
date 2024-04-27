%  modelRDMs is a user-editable function which specifies the models which
%  brain-region RDMs should be compared to, and which specifies which kinds of
%  analysis should be performed.
%
%  Models should be stored in the "Models" struct as a single field labeled
%  with the model's name (use underscores in stead of spaces).
%  
%  Cai Wingfield 11-2009

function Models = modelRDMs()

nconditions=24;

RDM=load('E:\ActionAttention_RSA\RDMs.mat');
low_level=load('E:\ActionAttention_RSA\lowlevel_vision.mat');

Models.visual_model=1-low_level.simMatrix;
Models.task_model=RDM.RDM.task_model;
Models.actor_model=RDM.RDM.actor_model;
Models.effector_model=RDM.RDM.effector_model;
Models.target_model=RDM.RDM.target_model;
Models.random = squareform(pdist(rand(nconditions,nconditions)));
% 
% att_act_1=ones(nconditions);
% att_act_1(logical(eye(nconditions)))=0; % fix the zero-diagonal
% att_act_1(1:8,1:8)=0;
% 
% Models.attend_actor_1=att_act_1;
% 
% att_eff_1=ones(nconditions);
% att_eff_1(logical(eye(nconditions)))=0; % fix the zero-diagonal
% att_eff_1(9:16,9:16)=0;
% 
% Models.attend_effector_1=att_eff_1;
% 
% att_tar_1=ones(nconditions);
% att_tar_1(logical(eye(nconditions)))=0; % fix the zero-diagonal
% att_tar_1(17:24,17:24)=0;
% 
% Models.attend_target_1=att_tar_1;
% 
% att_act_2=ones(nconditions);
% att_act_2(logical(eye(nconditions)))=0; % fix the zero-diagonal
% att_act_2(1:8,1:8)=0;
% att_act_2(9:24,9:24)=0;
% 
% Models.attend_actor_2=att_act_2;
% 
% att_eff_2=ones(nconditions);
% att_eff_2(logical(eye(nconditions)))=0; % fix the zero-diagonal
% att_eff_2(9:16,9:16)=0;
% att_eff_2(1:8,1:8)=0;
% att_eff_2(17:24,17:24)=0;
% att_eff_2(1:8,17:24)=0;
% att_eff_2(17:24,1:8)=0;
% 
% Models.attend_effector_2=att_eff_2;
% 
% att_tar_2=ones(nconditions);
% att_tar_2(logical(eye(nconditions)))=0; % fix the zero-diagonal
% att_tar_2(1:16,1:16)=0;
% att_tar_2(17:24,17:24)=0;
% 
% Models.attend_target_2=att_tar_2;

end%function
