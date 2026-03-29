function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  
  // Default environment is 'dev'
  if (!env) {
    env = 'dev';
  }
  
  // Load environment-specific configuration
  var envConfig = karate.read('classpath:config/' + env + '.json');
  
  // Base configuration with environment-specific values
  var config = {
    env: env,
    baseUrl: envConfig.baseUrl,
    apiTimeout: envConfig.timeout,
    retryEnabled: envConfig.retryEnabled,
    retryCount: envConfig.retryCount,
    debugMode: envConfig.debugMode,
    parallelThreads: envConfig.parallelThreads,
    logLevel: envConfig.logLevel,
    
    // Test credentials (from Fake Store API documentation)
    testUsers: {
      validUser: {
        username: 'johnd',
        password: 'm38rmF$'
      },
      invalidUser: {
        username: 'invaliduser',
        password: 'wrongpassword'
      }
    },
    
    // API endpoints
    endpoints: {
      auth: '/auth/login',
      products: '/products',
      carts: '/carts',
      users: '/users',
      categories: '/products/categories'
    },
    
    // Default headers
    defaultHeaders: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    }
  };
  
  // Load TestDataFactory for dynamic test data generation
  var TestDataFactory = Java.type('utils.TestDataFactory');
  config.TestDataFactory = TestDataFactory;
  
  // Configure timeouts
  karate.configure('connectTimeout', 10000);
  karate.configure('readTimeout', config.apiTimeout);
  karate.configure('logPrettyRequest', envConfig.debugMode);
  karate.configure('logPrettyResponse', envConfig.debugMode);
  
  karate.log('Current environment:', env);
  karate.log('Base URL:', config.baseUrl);
  karate.log('Debug Mode:', config.debugMode);
  karate.log('Parallel Threads:', config.parallelThreads);
  
  return config;
}