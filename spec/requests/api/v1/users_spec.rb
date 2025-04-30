require 'swagger_helper'

RSpec.describe 'User Authentication', type: :request do
  path '/users' do
    post 'User registration' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              password: { type: :string },
              mobile_number: { type: :string }
            },
            required: ['name', 'email', 'password', 'mobile_number']
          }
        },
        required: ['user']
      }

      response '201', 'User created successfully' do
        let(:user) { { user: attributes_for(:user) } }
        schema type: :object, properties: {
          id: { type: :integer },
          name: { type: :string },
          email: { type: :string },
          mobile_number: { type: :string }
        }
        run_test!
      end

      response '422', 'Invalid registration request' do
        let(:user) { { user: attributes_for(:user, :invalid) } }
        schema type: :object, properties: { errors: { type: :array, items: { type: :string } } }
        run_test!
      end
    end
  end

  path '/users/sign_in' do
    post 'User login' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: ['email', 'password']
          }
        },
        required: ['user']
      }
  
      response '200', 'User logged in successfully' do
        let!(:user_record) { create(:user, password: 'password123') }
        let(:user) do
          {
            user: {
              email: user_record.email,
              password: 'password123'
            }
          }
        end
  
        schema type: :object, properties: {
          id: { type: :integer },
          email: { type: :string },
          name: { type: :string },
          mobile_number: { type: :string },
          token: { type: :string }
        }
  
        example 'application/json', :success, {
          id: 1,
          email: 'user@example.com',
          name: 'Aalek',
          mobile_number: '+12345678901',
          token: 'some_jwt_token_here'
        }
  
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['email']).to eq(user_record.email)
          expect(data['token']).not_to be_nil
        end
      end
  
      response '401', 'Unauthorized login attempt' do
        let(:user) do
          {
            user: {
              email: 'wrong@example.com',
              password: 'wrongpass'
            }
          }
        end
  
        schema type: :object, properties: {
          error: { type: :string }
        }
  
        example 'application/json', :unauthorized, {
          error: 'Invalid email or password'
        }
  
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['error']).to eq('Invalid Email or password.')
        end
      end
    end
  end
  

  path '/users/sign_out' do
    delete 'User logout' do
      tags 'Authentication'
      produces 'application/json'
  
      response '204', 'User logged out successfully' do
        run_test!
      end
    end
  end

  path '/api/v1/current_user' do
    get 'Fetch current user' do
      tags 'Users'
      produces 'application/json'
      response '200', 'User details returned' do
        let(:user) { create(:user) }

        before do
          sign_in user 
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['email']).to eq(user.email)
        end
      end

      response '401', 'Unauthorized access' do
        run_test!
      end
    end
  end
end