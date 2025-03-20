
def magnitude(vector): 
    return math.sqrt(sum(pow(element, 2) for element in vector))

def distance_plane_to_point(plane, point):
    return np.abs(plane[0]*point[0] + plane[1]*point[1] + plane[2]*point[2] + plane[3]) / np.sqrt(plane[0]**2 + plane[1]**2+  plane[2]**2) # formula for distance from a point to a plane

def analyze_critical_points(f, vars):
    """
    Finds and classifies critical points of f(x), f(x,y), or f(x,y,z).
    
    Parameters:
        f    : A symbolic function in SageMath.
        vars : A list of variables (e.g., [x], [x,y], or [x,y,z]).
    
    Returns:
        A dictionary of critical points with their classifications.
    """
    #from sympy import Matrix

    num_vars = len(vars)
    
    # Compute first-order partial derivatives (gradient)
    grad = [diff(f, var) for var in vars]
    
    # Solve for critical points
    crit_solutions = solve(grad, vars, solution_dict=True)
    
    if not crit_solutions:
        print("No critical points found.")
        return {}

    critical_points = []
    classifications = {}

    for sol in crit_solutions:
        try:
            point = tuple(sol[var] for var in vars)  # Ensure we get a full (x,y) or (x,y,z) point
        except KeyError:
            print(f"Skipping incomplete solution: {sol}")
            continue

        critical_points.append(point)

        if num_vars == 2:
            # Compute second-order partial derivatives
            f_xx = diff(grad[0], vars[0])
            f_yy = diff(grad[1], vars[1])
            f_xy = diff(grad[0], vars[1])

            # Compute Hessian determinant (Discriminant)
            D = f_xx * f_yy - f_xy**2

            # Evaluate at the critical point
            D_val = D.subs(sol)
            f_xx_val = f_xx.subs(sol)

            if D_val > 0:
                if f_xx_val > 0:
                    classifications[point] = "Local Minimum"
                elif f_xx_val < 0:
                    classifications[point] = "Local Maximum"
            elif D_val < 0:
                classifications[point] = "Saddle Point"
            else:
                classifications[point] = "Inconclusive (Hessian determinant = 0)"

    return classifications

def closest_point_on_function(f, point):
    from scipy.optimize import minimize
    """
    Find the point on the function f that is closest to the given point in space.
    
    Parameters:
    - f: The function (in 2D: f(x), in 3D: f(x, y)).
    - point: The point in space (in 2D: (x0, y0), in 3D: (x0, y0, z0)).
    - initial_guess: Initial guess for the optimization (in 2D: x_guess, in 3D: (x_guess, y_guess)).
    
    Returns:
    - The point on the function f that is closest to the given point.
    """
    if len(point) == 2:
        # 2D case: f is a function of one variable
        initial_guess = (0.0)
        x0, y0 = point
        def distance_squared(x):
            return (x[0] - x0)**2 + (f(x[0]) - y0)**2
        
        # Minimize the distance squared
        result = minimize(distance_squared, [initial_guess])
        x_min = result.x[0]
        return (x_min, f(x_min))
    
    elif len(point) == 3:
        initial_guess = (0.0,0.0)
        # 3D case: f is a function of two variables
        x0, y0, z0 = point
        def distance_squared(vars):
            x, y = vars
            return (x - x0)**2 + (y - y0)**2 + (f(x, y) - z0)**2
        
        # Minimize the distance squared
        result = minimize(distance_squared, initial_guess)
        x_min, y_min = result.x
        return (x_min, y_min, f(x_min, y_min))
    
    else:
        raise ValueError("The point must be in 2D or 3D space.")

def error_function(f, point):
    # Define the variables
    x, y = var('x y')
    
    # Extract the point (x0, y0)
    x0, y0 = point
    
    # Compute f(x0, y0)
    f0 = f.subs(x=x0, y=y0)
    
    # Compute partial derivatives fx and fy
    fx = f.diff(x)
    fy = f.diff(y)
    
    # Evaluate partial derivatives at (x0, y0)
    fx0 = fx.subs(x=x0, y=y0)
    fy0 = fy.subs(x=x0, y=y0)
    
    # Compute the linear approximation
    linear_approx = f0 + fx0 * (x - x0) + fy0 * (y - y0)
    
    # Compute the error function E(x, y)
    E = f - linear_approx
    
    return E

def linear_approximation(f, point):
    # Determine the number of variables in f
    variables = f.variables()
    n = len(variables)
    
    if n == 1:
        # Case for f(x): single-variable function
        x = variables[0]
        fx = f.diff(x)
        
        # Evaluate function and derivative at the point
        x0 = point[0]
        f0 = f.subs(x=x0)
        fx0 = fx.subs(x=x0)
        
        # Linear approximation: L(x) = f(x0) + f'(x0)*(x - x0)
        linear_approx = f0 + fx0 * (x - x0)
    
    elif n == 2:
        # Case for f(x, y): two-variable function
        x, y = variables
        fx = f.diff(x)
        fy = f.diff(y)
        
        # Evaluate function and partial derivatives at the point
        x0, y0 = point
        f0 = f.subs(x=x0, y=y0)
        fx0 = fx.subs(x=x0, y=y0)
        fy0 = fy.subs(x=x0, y=y0)
        
        # Linear approximation: L(x, y) = f(x0, y0) + fx0*(x - x0) + fy0*(y - y0)
        linear_approx = f0 + fx0 * (x - x0) + fy0 * (y - y0)
    
    elif n == 3:
        # Case for f(x, y, z): three-variable function
        x, y, z = variables
        fx = f.diff(x)
        fy = f.diff(y)
        fz = f.diff(z)
        
        # Evaluate function and partial derivatives at the point
        x0, y0, z0 = point
        f0 = f.subs(x=x0, y=y0, z=z0)
        fx0 = fx.subs(x=x0, y=y0, z=z0)
        fy0 = fy.subs(x=x0, y=y0, z=z0)
        fz0 = fz.subs(x=x0, y=y0, z=z0)
        
        # Linear approximation: L(x, y, z) = f(x0, y0, z0) + fx0*(x - x0) + fy0*(y - y0) + fz0*(z - z0)
        linear_approx = f0 + fx0 * (x - x0) + fy0 * (y - y0) + fz0 * (z - z0)
    
    else:
        raise ValueError("The function must have 1, 2, or 3 variables.")
    
    return linear_approx

