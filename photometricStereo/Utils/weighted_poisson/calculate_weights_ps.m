function  [weights] = calculate_weights_ps(Itilde,mask,b,epsilon)
	
	if (~exist('mask','var')|isempty(mask)) disp('image size must be provided through a mask'); return; end;
	if (~exist('b','var')|isempty(b)) b=1; end;
	if (~exist('epsilon','var')|isempty(epsilon)) epsilon=0.01; end;
	
	normalisation=sqrt(sum(Itilde.*Itilde,2));
	I_normalise=Itilde./(normalisation*(ones(1,size(Itilde,2))));
	non_mask=find(mask==0);
	I_normalise(non_mask,:)=0;
	% Comparaison avec le voisin de gauche :
	diff = zeros(size(Itilde,1),8);
	for i=1:size(Itilde,2)
		% image translatee vers la droite
		I_ = reshape(I_normalise(:,i),size(mask));
		I_modifiee = [I_(:,1),I_(:,1:end-1)];
		diff(:,1) = max(diff(:,1),abs(I_(:)-I_modifiee(:)));
	end
	% Comparaison avec le voisin de droite :
	for i=1:size(Itilde,2)
		% image translatee vers la gauche
		I_ = reshape(I_normalise(:,i),size(mask));
		I_modifiee = [I_(:,2:end),I_(:,end)];
		diff(:,2) = max(diff(:,2),abs(I_(:)-I_modifiee(:)));
	end
	% Comparaison avec le voisin du dessus :
	for i=1:size(Itilde,2)
		% image translatee vers le bas
		I_ = reshape(I_normalise(:,i),size(mask));
		I_modifiee = [I_(1,:);I_(1:end-1,:)];
		diff(:,3) = max(diff(:,3),abs(I_(:)-I_modifiee(:)));
	end
	% Comparaison avec le voisin du dessous :
	for i=1:size(Itilde,2)
		% image translatee vers le haut
		I_ = reshape(I_normalise(:,i),size(mask));
		I_modifiee = [I_(2:end,:);I_(end,:)];
		diff(:,4) = max(diff(:,4),abs(I_(:)-I_modifiee(:)));
	end
	% Comparaison avec le voisin du dessus a gauche :
	for i=1:size(Itilde,2)
		% image translatee vers le bas
		I_ = reshape(I_normalise(:,i),size(mask));
		I_modifiee = [I_(1,:);I_(1:end-1,:)];
		% image translatee vers la droite
		I_modifiee = [I_modifiee(:,1),I_modifiee(:,1:end-1)];
		diff(:,5) = max(diff(:,5),abs(I_(:)-I_modifiee(:)));
	end
	% Comparaison avec le voisin du dessus a droite :
	for i=1:size(Itilde,2)
		% image translatee vers le bas
		I_ = reshape(I_normalise(:,i),size(mask));
		I_modifiee = [I_(1,:);I_(1:end-1,:)];
		% image translatee vers la gauche
		I_modifiee = [I_modifiee(:,2:end),I_modifiee(:,end)];
		diff(:,6) = max(diff(:,6),abs(I_(:)-I_modifiee(:)));
	end
	% Comparaison avec le voisin du dessous a gauche :
	for i=1:size(Itilde,2)
		% image translatee vers le haut
		I_ = reshape(I_normalise(:,i),size(mask));
		I_modifiee = [I_(2:end,:);I_(end,:)];
		% image translatee vers la droite
		I_modifiee = [I_modifiee(:,1),I_modifiee(:,1:end-1)];
		diff(:,7) = max(diff(:,7),abs(I_(:)-I_modifiee(:)));
	end
	% Comparaison avec le voisin du dessous a droite :
	for i=1:size(Itilde,2)
		% image translatee vers le haut
		I_ = reshape(I_normalise(:,i),size(mask));
		I_modifiee = [I_(2:end,:);I_(end,:)];
		% image translatee vers la gauche
		I_modifiee = [I_modifiee(:,2:end),I_modifiee(:,end)];
		diff(:,8) = max(diff(:,8),abs(I_(:)-I_modifiee(:)));
	end
	% Le max :
	diff=max(diff,[],2);
	weights=reshape(diff,size(mask));
	weights=max(epsilon,exp(-b*weights));	
end
