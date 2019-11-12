classdef Beta3pSecondKind < handle
% We use the parameterization and variables names that are also used in 
% 10.1016/S0029-8018(98)00022-5, equation 5
   properties
      Alpha
      K
      N
   end
   
   methods
      function obj = Beta3pSecondKind(alpha, k, n)
         if nargin > 2
            obj.Alpha = alpha;
            obj.K = k;
            obj.N = n;
         end
      end
      
      function parmHat = fitDist(this, sample)
          % Estimate the parameters of the distribution using maximum 
          % likelihood estimation.
          start = [1 1 1];
          lb = [0 0 0];
          ub = [Inf Inf Inf];
          parmHat = mle(sample, 'pdf', @(x, alpha, k, n) ...
              this.pdf(sample, alpha, k, n), ...
              'start', start, 'lower', lb, 'upper', ub);
          this.Alpha = parmHat(1);
          this.K = parmHat(2);
          this.N = parmHat(3);
      end
      
      function f = pdf(this, x, alpha, k, n)
          pdf = @(x, alpha, k, n) alpha ./ (beta(k, n - k + 1)) .* ...
              ((alpha .* x).^(n - k)) ./ ((1 + alpha .* x).^(n + 1));
          % Similar to 10.1016/S0029-8018(98)00022-5, equation 5. However, 
          % for correctedness, CDF(inf)=1, we added a factor of alpha.
         
          if nargin < 3
              f = pdf(x, this.Alpha, this.K, this.N);
          else
              if n - k + 1 < 0 % Not allowed, see 10.1016/S0029-8018(98)00022-5, equation 5
                  f = zeros(size(x)) + 10^(-10);
              else
                  f = pdf(x, alpha, k, n);
              end
          end
      end
      
      function F = cdf(this, x)
          % Cumulative distribution function.
          F = nan(size(x));
          for i = 1:length(x)
              if x(i) > 0
                  F(i) = integral(@this.pdf,0,x(i));
              else
                  F(i) = 0;
              end
          end
      end
      
      function x = icdf(this, p)
          % Inverse cumulative distribution function.
          fun = @this.cdf;
          x0 = 2;
          x = nan(size(p));
          for i = 1:length(p)
            x(i) = fzero(@(x) fun(x) - p(i), x0);
          end
      end
      
      function x = drawSample(this, n)
          if n < 2
              n = 1;
          end
          p = rand(n, 1);
          x = this.icdf(p);
      end
      
      function val = negativeloglikelihood(this, x)
          % Negative log-likelihood value (as a metric of goodness of fit).
          val = sum(-log(pdf(x, this.ALpha, this.K, this.N)));
      end
      
      function mae = meanabsoluteerror(this, sample, pi)
          % Mean absolute error (as a measure of goodness of fit).
          n = length(sample);
          if nargin < 3
              i = [1:n]';
              pi = (i - 0.5) ./ n;
          end
          xi = sort(sample);
          xhati = this.icdf(pi); % The prediction.
          mae = sum(abs(xi - xhati)) / n;
      end
      
      function ax = qqplot(this, sample, qqFig, qqAx, lineColor)
          if nargin > 2
              set(0, 'currentfigure', qqFig);
              set(qqFig, 'currentaxes', qqAx);
          else
              qqFig = figure();
          end
          if nargin < 4
              lineColor = [0 0 0];
          end
          n = length(sample);
          i = [1:n]';
          pi = (i - 0.5) ./ n;
          xi = sort(sample);
          xhati = this.icdf(pi); % The prediction.
          hold on
          plot(xhati, xi, 'kx'); 
          plot(xhati, xhati, 'color', lineColor, 'linewidth', 1.5);
          xlabel('Theoretical quantiles');
          ylabel('Ordered values');
      end
   end
end
