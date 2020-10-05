classdef Sampler < handle
    
    properties
        % -- TotalSamples should always be in Square form -- % 
        totalSamples           = 2;
        totalNumOfSamplesSets  = 83; % any random value
        
        count                  = 1;
        jump                   = 1;
        
        shuffledIndicesList    = 0; % 1D
        samplesList            = []; % 2D
        diskSamplesList        = [];
%         hemisphereSamplesList  = [];
    end
    
    methods
        % -- Class Constructer -- % 
        function[obj] = Sampler ( InTotalSamples)
            obj.totalSamples          = InTotalSamples;
            
            obj.generatedSample();
            obj.setupShuffledIndices();
%             obj.mapSampleToUnitDisk()
            
%             e = 1;
%             obj.mapSamplesToHemisphere(e)
            
            
        end
        
        function [obj] =  generatedSample(obj)
            
            n = floor( sqrt(obj.totalSamples) ) ;
            
            for p = 0:obj.totalNumOfSamplesSets
                for j = 0:n
                    for k =0:n
                        x = (k + rand) / n;
                        y = (j + rand) / n ;
                        
                        obj.samplesList{end+1} = [x,y];
                        
                    end
                end
            end
            
        end
        
        function [OutSamplePoint] = sampleUnitSquare(obj)
            tempJumpIndex             = obj.jump;
            tempTotalsamples          = obj.totalSamples;
            tempTotalNumOfSamplesSets = obj.totalNumOfSamplesSets;
            tempCount                 = obj.count;
            tempshuffledIndices       = obj.shuffledIndicesList;
            
            if ( rem(tempCount,tempTotalsamples ) == 0 )
                tempJumpIndex = floor(rem(rand,tempTotalNumOfSamplesSets) * tempTotalsamples);
            end
            
            tempCount =  obj.count + 1;
            
            
            i = floor(tempJumpIndex + ...
                tempshuffledIndices( rem( tempJumpIndex+ tempCount, tempTotalsamples )+1 ) ) ;
            
            
            OutSamplePoint = obj.samplesList{i};
            
            
            obj.jump = tempJumpIndex;
            obj.count = tempCount;
        end
        
        function [obj] = setupShuffledIndices(obj)
            
            
            obj.shuffledIndicesList = zeros(obj.totalSamples, 1);
            tempIndices = zeros(obj.totalSamples,1);
            
            
            for j = 1:obj.totalSamples
                tempIndices(j) = j;
            end
            
            for p = 1:obj.totalNumOfSamplesSets
                % -- shuffle the value with in indcies -- %
                tempIndices= tempIndices(randperm(length(tempIndices)));
                
                for j=1:obj.totalSamples
                    obj.shuffledIndicesList(j) = tempIndices(j);
                end
            end
            
            
            
        end
        
        
        function[obj] = mapSampleToUnitDisk(obj)
            [~, totalNoOfSamples] = size(obj.samplesList);
%             r = 0;
%             phi = 0;
%             tempSamplePoint.x = 0;
%             tempSamplePoint.y = 0;
            
            obj.diskSamplesList = cell(1,totalNoOfSamples);
            
            for j = 1:totalNoOfSamples
                tempSamplePoint.x = 2.0 * obj.samplesList{j}(1) - 1.0; % x
                tempSamplePoint.y = 2.0 * obj.samplesList{j}(2) - 1.0; % ys
                
                if (tempSamplePoint.x > -tempSamplePoint.y)
                    if (tempSamplePoint.x > tempSamplePoint.y)
                        r = tempSamplePoint.x;
                        phi =  tempSamplePoint.y / tempSamplePoint.x;
                    else
                        r = tempSamplePoint.y;
                        phi = 2 - tempSamplePoint.x / tempSamplePoint.y;
                    end
                else
                    if (tempSamplePoint.x < tempSamplePoint.y)
                        r = -tempSamplePoint.x;
                        phi = 4+ tempSamplePoint.y / tempSamplePoint.x;
                    else
                        r = -tempSamplePoint.y;
                        if(tempSamplePoint.y ~= 0)
                            phi = 2 - tempSamplePoint.x / tempSamplePoint.y;
                        else
                            phi = 0;
                        end
                        
                    end
                    
                end
                
                phi = phi * pi/4;
                obj.diskSamplesList{j} = [r* cos(phi), r*sin(phi)];
            end
            
            
        end
        
        % -- Default value of InValue =1, more value = less uniform
        % distribution of points in in hemisphere -- %
%         function [obj] = mapSamplesToHemisphere(obj, InValue)
%             [~, totalNoOfSamples] = size(obj.samplesList);
%             
%             obj.hemisphereSamplesList = cell(1,totalNoOfSamples);
%             
%             for j = 1:totalNoOfSamples
%                 
%                 tempSamplePoint.x = obj.samplesList{j}(1);
%                 tempSamplePoint.y = obj.samplesList{j}(2);
%                 
%                     cosPhi       = cos(2 * pi* tempSamplePoint.x );
%                     sinPhi       = sin(2 * pi *tempSamplePoint.y );
%                     cosTheta     = (1 - tempSamplePoint.y) ^ (1/InValue + 1);
%                     sinTheta     = sqrt(1-cosTheta * cosTheta);
%                     PointU       = sinTheta* cosPhi;
%                     PointV       = sinTheta* sinPhi;
%                     PointW       = cosTheta;
%                 
%                 obj.hemisphereSamplesList{j} = [PointU, PointV, PointW];
%                 
%             end
%             
%         end
%         
%         
%         function[Out3DPoint] = getSamplesToHemisphere(obj)
%             
%             tempJumpIndex             = obj.jump;
%             tempTotalsamples          = obj.totalSamples;
%             tempTotalNumOfSamplesSets = obj.totalNumOfSamplesSets;
%             tempCount                 = obj.count;
%             tempshuffledIndices       = obj.shuffledIndicesList;
%             
%             if ( rem(tempCount,tempTotalsamples ) == 0 )
%                 tempJumpIndex = floor(rem(rand,tempTotalNumOfSamplesSets) * tempTotalsamples);
%             end
%             
%             tempCount =  obj.count + 1;
%             
%             
%             hemiSphereSamplesIndex = floor(tempJumpIndex + ...
%             tempshuffledIndices( rem( tempJumpIndex+ tempCount, tempTotalsamples ) + 1 ) ) ;
%             
%             
%             Out3DPoint  = obj.hemisphereSamplesList{ hemiSphereSamplesIndex };
%             
%             
%             obj.jump    = tempJumpIndex;
%             obj.count   = tempCount;
%             
%         end
    end
    
    
end