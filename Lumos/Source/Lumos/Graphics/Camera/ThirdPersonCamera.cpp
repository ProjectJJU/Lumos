#include "Precompiled.h"
#include "ThirdPersonCamera.h"
#include "Core/OS/Input.h"
#include "Camera.h"
#include "Core/Application.h"
#include "Core/OS/Window.h"
#include "Maths/MathsUtilities.h"
#include "Maths/Transform.h"

namespace Lumos
{

    ThirdPersonCameraController::ThirdPersonCameraController()
    {
        m_Velocity              = Vec3(0.0f);
        m_MouseSensitivity      = 0.00001f;
        m_ZoomDampeningFactor   = 0.00001f;
        m_DampeningFactor       = 0.00001f;
        m_RotateDampeningFactor = 0.0000001f;
    }

    ThirdPersonCameraController::~ThirdPersonCameraController()
    {
    }

    void ThirdPersonCameraController::HandleMouse(Maths::Transform& transform, float dt, float xpos, float ypos)
    {
        static bool mouseHeld = false;
        if(Input::Get().GetMouseClicked(InputCode::MouseKey::ButtonRight))
        {
            mouseHeld = true;
            Application::Get().GetWindow()->HideMouse(true);
            Input::Get().SetMouseMode(MouseMode::Captured);
            m_StoredCursorPos   = Vec2(xpos, ypos);
            m_PreviousCurserPos = m_StoredCursorPos;
        }

        if(Input::Get().GetMouseHeld(InputCode::MouseKey::ButtonRight))
        {
            m_MouseSensitivity = 0.0002f;
            m_RotateVelocity   = Vec2((xpos - m_PreviousCurserPos.x), (ypos - m_PreviousCurserPos.y)) * m_MouseSensitivity * 10.0f;
        }
        else
        {
            if(mouseHeld)
            {
                mouseHeld = false;
                Application::Get().GetWindow()->HideMouse(false);
                Application::Get().GetWindow()->SetMousePosition(m_StoredCursorPos);
                Input::Get().SetMouseMode(MouseMode::Visible);
            }
        }

        Quat rotation  = transform.GetLocalOrientation();
        Quat rotationX = Quat::Rotation(-m_RotateVelocity.y, Vec3(1.0f, 0.0f, 0.0f));
        Quat rotationY = Quat::Rotation(-m_RotateVelocity.x, Vec3(0.0f, 1.0f, 0.0f));

        rotation = rotationY * rotation;
        rotation = rotation * rotationX;
        transform.SetLocalOrientation(rotation);

        m_PreviousCurserPos = Vec2(xpos, ypos);
        m_RotateVelocity    = m_RotateVelocity * pow(m_RotateDampeningFactor, dt);

        UpdateScroll(transform, Input::Get().GetScrollOffset(), dt);
    }

    void ThirdPersonCameraController::HandleKeyboard(Maths::Transform& transform, float dt)
    {
        // Temp
        return;
        float multiplier = 1000.0f;

        if(Input::Get().GetKeyHeld(InputCode::Key::LeftShift))
        {
            multiplier = 10000.0f;
        }

        m_CameraSpeed = multiplier * dt;

        if(Input::Get().GetMouseHeld(InputCode::MouseKey::ButtonRight))
        {
            if(Input::Get().GetKeyHeld(InputCode::Key::W))
            {
                m_Velocity -= transform.GetForwardDirection() * m_CameraSpeed;
            }

            if(Input::Get().GetKeyHeld(InputCode::Key::S))
            {
                m_Velocity += transform.GetForwardDirection() * m_CameraSpeed;
            }

            if(Input::Get().GetKeyHeld(InputCode::Key::A))
            {
                m_Velocity -= transform.GetRightDirection() * m_CameraSpeed;
            }

            if(Input::Get().GetKeyHeld(InputCode::Key::D))
            {
                m_Velocity += transform.GetRightDirection() * m_CameraSpeed;
            }

            if(Input::Get().GetKeyHeld(InputCode::Key::Q))
            {
                m_Velocity -= transform.GetUpDirection() * m_CameraSpeed;
            }

            if(Input::Get().GetKeyHeld(InputCode::Key::E))
            {
                m_Velocity += transform.GetUpDirection() * m_CameraSpeed;
            }
        }

        if(Maths::Length(m_Velocity) > Maths::M_EPSILON)
        {
            Vec3 position = transform.GetLocalPosition();
            position += m_Velocity * dt;
            transform.SetLocalPosition(position);
            m_Velocity = m_Velocity * pow(m_DampeningFactor, dt);
        }
    }
}
